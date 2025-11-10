package com.vhsystem.defaultlabel;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.osgi.framework.BundleContext;

import com.archimatetool.editor.model.IEditorModelManager;
import com.archimatetool.model.IArchimateElement;
import com.archimatetool.model.INameable;

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
        
        // Log detalhado
        System.out.println("[DefaultLabel] Notification: eventType=" + eventType + 
                         ", notifier=" + (notifier != null ? notifier.getClass().getSimpleName() : "null") +
                         ", newValue=" + (newValue != null ? newValue.getClass().getSimpleName() : "null"));
        
        // Verifica se é um DiagramModelArchimateObject sendo adicionado ao diagrama
        if (newValue instanceof com.archimatetool.model.IDiagramModelArchimateObject) {
            System.out.println("[DefaultLabel] Objeto de diagrama detectado!");
            com.archimatetool.model.IDiagramModelArchimateObject diagramObject = 
                (com.archimatetool.model.IDiagramModelArchimateObject) newValue;
            applyDefaultLabelToDiagramObject(diagramObject);
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
        System.out.println("[DefaultLabel] Verificando elemento: " + className);
        
        // Obtém o label padrão para este tipo de elemento
        final String defaultLabel = labelManager.getDefaultLabel(element.getClass());
        System.out.println("[DefaultLabel] Label padrão para " + className + ": '" + 
                         (defaultLabel != null ? defaultLabel : "(não configurado)") + "'");
        
        if (defaultLabel == null || defaultLabel.trim().isEmpty()) {
            System.out.println("[DefaultLabel] Sem label padrão configurado para este tipo.");
            return;
        }
        
        System.out.println("[DefaultLabel] Aplicando label expression ao objeto do diagrama");
        
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
                            
                            // Define o label expression como uma feature
                            featuresObject.getFeatures().putString("labelExpression", defaultLabel);
                            System.out.println("[DefaultLabel] ✅ Label Expression aplicado com sucesso: '" + defaultLabel + "'");
                        } else {
                            System.err.println("[DefaultLabel] ❌ Objeto do diagrama não suporta IFeatures!");
                        }
                    } catch (Exception e) {
                        System.err.println("[DefaultLabel] ❌ ERRO ao aplicar label expression: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            });
        } else {
            System.out.println("[DefaultLabel] Display não disponível!");
        }
    }
}

