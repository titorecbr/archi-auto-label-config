package com.vhsystem.defaultlabel;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.osgi.framework.BundleContext;

import com.archimatetool.editor.model.IEditorModelManager;
import com.archimatetool.model.IArchimateElement;
import com.archimatetool.model.INameable;
import com.archimatetool.model.IArchimatePackage;

/**
 * Plugin principal para gerenciar labels padrão no Archi
 */
public class DefaultLabelPlugin extends AbstractUIPlugin {
    
    public static final String PLUGIN_ID = "com.vhsystem.defaultlabel";
    
    private static DefaultLabelPlugin plugin;
    
    private LabelManager labelManager;
    private PropertyChangeListener modelListener;
    
    public DefaultLabelPlugin() {
        plugin = this;
    }
    
    public static DefaultLabelPlugin getDefault() {
        return plugin;
    }
    
    @Override
    public void start(BundleContext context) throws Exception {
        super.start(context);
        
        // Inicializa o gerenciador de labels
        labelManager = new LabelManager();
        
        // Registra listener para eventos do modelo
        modelListener = new PropertyChangeListener() {
            @Override
            public void propertyChange(PropertyChangeEvent evt) {
                // Escuta eventos ECORE (criação/modificação de objetos)
                if (IEditorModelManager.PROPERTY_ECORE_EVENT.equals(evt.getPropertyName())) {
                    Object newValue = evt.getNewValue();
                    if (newValue instanceof Notification) {
                        handleNotification((Notification) newValue);
                    }
                }
            }
        };
        
        IEditorModelManager.INSTANCE.addPropertyChangeListener(modelListener);
    }
    
    @Override
    public void stop(BundleContext context) throws Exception {
        // Remove listener
        if (modelListener != null) {
            IEditorModelManager.INSTANCE.removePropertyChangeListener(modelListener);
        }
        
        super.stop(context);
    }
    
    public LabelManager getLabelManager() {
        return labelManager;
    }
    
    /**
     * Processa notificações de mudanças no modelo
     */
    private void handleNotification(Notification notification) {
        // Log para debug
        int eventType = notification.getEventType();
        Object notifier = notification.getNotifier();
        Object newValue = notification.getNewValue();
        Object oldValue = notification.getOldValue();
        
        // Log detalhado de TODAS as notificações
        System.out.println("[DefaultLabel] ========== NOTIFICATION ==========");
        System.out.println("[DefaultLabel] eventType=" + eventType + " (" + getEventTypeName(eventType) + ")");
        System.out.println("[DefaultLabel] notifier=" + (notifier != null ? notifier.getClass().getSimpleName() : "null"));
        System.out.println("[DefaultLabel] newValue=" + (newValue != null ? newValue.getClass().getSimpleName() : "null"));
        System.out.println("[DefaultLabel] oldValue=" + (oldValue != null ? oldValue.getClass().getSimpleName() : "null"));
        
        // Verifica se o newValue é um DiagramModelArchimateObject
        if (newValue instanceof com.archimatetool.model.IDiagramModelArchimateObject) {
            System.out.println("[DefaultLabel] ✓ Objeto de diagrama detectado via newValue!");
            com.archimatetool.model.IDiagramModelArchimateObject diagramObject = 
                (com.archimatetool.model.IDiagramModelArchimateObject) newValue;
            applyDefaultLabelToDiagramObject(diagramObject);
        }
        // NOVO: Também verifica o notifier (pode ser o próprio objeto sendo modificado)
        else if (notifier instanceof com.archimatetool.model.IDiagramModelArchimateObject) {
            com.archimatetool.model.IDiagramModelArchimateObject diagramObject = 
                (com.archimatetool.model.IDiagramModelArchimateObject) notifier;
            
            // Verifica se é um evento de SET no elemento ArchiMate (quando o elemento é associado)
            if (eventType == Notification.SET && newValue instanceof com.archimatetool.model.IArchimateElement) {
                System.out.println("[DefaultLabel] ✓ Objeto de diagrama detectado via notifier (SET element)!");
                applyDefaultLabelToDiagramObject(diagramObject);
            }
        }
        
        System.out.println("[DefaultLabel] ========================================");
    }
    
    /**
     * Retorna o nome do tipo de evento para facilitar debug
     */
    private String getEventTypeName(int eventType) {
        switch (eventType) {
            case Notification.SET: return "SET";
            case Notification.UNSET: return "UNSET";
            case Notification.ADD: return "ADD";
            case Notification.REMOVE: return "REMOVE";
            case Notification.ADD_MANY: return "ADD_MANY";
            case Notification.REMOVE_MANY: return "REMOVE_MANY";
            case Notification.MOVE: return "MOVE";
            case Notification.REMOVING_ADAPTER: return "REMOVING_ADAPTER";
            case Notification.RESOLVE: return "RESOLVE";
            default: return "UNKNOWN(" + eventType + ")";
        }
    }
    
    /**
     * Aplica label padrão no objeto do diagrama
     * Define o "content" (Label Expression) do DiagramModelArchimateObject
     */
    private void applyDefaultLabelToDiagramObject(final com.archimatetool.model.IDiagramModelArchimateObject diagramObject) {
        if (diagramObject == null) {
            return;
        }
        
        // Obtém o elemento ArchiMate associado
        com.archimatetool.model.IArchimateElement element = diagramObject.getArchimateElement();
        if (element == null) {
            System.out.println("[DefaultLabel] Objeto de diagrama sem elemento associado!");
            return;
        }
        
        String className = element.getClass().getSimpleName();
        String fullClassName = element.getClass().getName();
        System.out.println("[DefaultLabel] ========================================");
        System.out.println("[DefaultLabel] Verificando elemento: " + className);
        System.out.println("[DefaultLabel] Classe completa: " + fullClassName);
        System.out.println("[DefaultLabel] Interfaces implementadas:");
        for (Class<?> iface : element.getClass().getInterfaces()) {
            System.out.println("[DefaultLabel]   - " + iface.getName());
        }
        
        // Obtém o label padrão para este tipo de elemento
        final String defaultLabel = labelManager.getDefaultLabel(element.getClass());
        System.out.println("[DefaultLabel] Label padrão para " + className + ": '" + 
                         (defaultLabel != null ? defaultLabel : "(não configurado)") + "'");
        
        if (defaultLabel == null || defaultLabel.trim().isEmpty()) {
            System.out.println("[DefaultLabel] ❌ Sem label padrão configurado para este tipo.");
            System.out.println("[DefaultLabel] ========================================");
            return;
        }
        
        System.out.println("[DefaultLabel] ✓ Aplicando label expression ao objeto do diagrama...");
        
        // Aplica o label na thread do SWT
        Display display = Display.getDefault();
        if (display != null && !display.isDisposed()) {
            display.asyncExec(new Runnable() {
                @Override
                public void run() {
                    try {
                        // Verifica se o objeto tem features (todos os objetos do diagrama têm)
                        if (diagramObject instanceof com.archimatetool.model.IFeatures) {
                            com.archimatetool.model.IFeatures featuresObject = 
                                (com.archimatetool.model.IFeatures) diagramObject;
                            
                            // Log estado antes
                            String oldValue = featuresObject.getFeatures().getString("labelExpression", "");
                            System.out.println("[DefaultLabel] Label expression ANTES: '" + oldValue + "'");
                            
                            // Define o label expression como uma feature
                            featuresObject.getFeatures().putString("labelExpression", defaultLabel);
                            
                            // Verifica se foi aplicado
                            String newValue = featuresObject.getFeatures().getString("labelExpression", "");
                            System.out.println("[DefaultLabel] Label expression DEPOIS: '" + newValue + "'");
                            
                            if (newValue.equals(defaultLabel)) {
                                System.out.println("[DefaultLabel] ✅ Label Expression aplicado com sucesso!");
                                
                                // IMPORTANTE: Força o refresh da visualização
                                // O label expression foi salvo, mas precisamos forçar a UI a atualizar
                                try {
                                    // Estratégia 1: Força refresh modificando o bounds (não muda nada visualmente)
                                    final com.archimatetool.model.IBounds bounds = diagramObject.getBounds();
                                    if (bounds != null) {
                                        // Muda e volta o bounds para disparar evento de modificação
                                        diagramObject.setBounds(bounds);
                                        System.out.println("[DefaultLabel] ✓ Refresh via setBounds");
                                    }
                                    
                                    // Estratégia 2: Força refresh via alpha (backup)
                                    Display.getDefault().asyncExec(new Runnable() {
                                        @Override
                                        public void run() {
                                            try {
                                                // Salva alpha atual
                                                int alpha = diagramObject.getAlpha();
                                                // Muda temporariamente
                                                diagramObject.setAlpha(alpha == 255 ? 254 : 255);
                                                // Volta ao valor original (força dois eventos)
                                                diagramObject.setAlpha(alpha);
                                                System.out.println("[DefaultLabel] ✓ Refresh visual forçado via setAlpha");
                                            } catch (Exception e) {
                                                System.err.println("[DefaultLabel] ⚠️  Erro no refresh visual: " + e.getMessage());
                                            }
                                        }
                                    });
                                    
                                } catch (Exception refreshEx) {
                                    System.err.println("[DefaultLabel] ⚠️  Erro ao forçar refresh: " + refreshEx.getMessage());
                                    refreshEx.printStackTrace();
                                }
                            } else {
                                System.err.println("[DefaultLabel] ⚠️  Label não foi aplicado corretamente!");
                            }
                            System.out.println("[DefaultLabel] ========================================");
                        } else {
                            System.err.println("[DefaultLabel] ❌ Objeto do diagrama não suporta IFeatures!");
                            System.out.println("[DefaultLabel] ========================================");
                        }
                    } catch (Exception e) {
                        System.err.println("[DefaultLabel] ❌ ERRO ao aplicar label expression: " + e.getMessage());
                        e.printStackTrace();
                        System.out.println("[DefaultLabel] ========================================");
                    }
                }
            });
        } else {
            System.out.println("[DefaultLabel] ❌ Display não disponível!");
            System.out.println("[DefaultLabel] ========================================");
        }
    }
}

