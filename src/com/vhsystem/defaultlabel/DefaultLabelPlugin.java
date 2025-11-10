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
        System.out.println("[DefaultLabel] ========================================");
        System.out.println("[DefaultLabel] 🚀 Plugin construtor chamado!");
        System.out.println("[DefaultLabel] Forçando inicialização do LabelManager...");
        // Força a inicialização do LabelManager singleton
        labelManager = LabelManager.getInstance();
        System.out.println("[DefaultLabel] ✓ LabelManager inicializado!");
        System.out.println("[DefaultLabel] ========================================");
    }
    
    public static DefaultLabelPlugin getDefault() {
        return plugin;
    }
    
    @Override
    public void start(BundleContext context) throws Exception {
        System.out.println("[DefaultLabel] ========================================");
        System.out.println("[DefaultLabel] 🚀 Plugin.start() chamado!");
        System.out.println("[DefaultLabel] Iniciando plugin...");
        
        super.start(context);
        
        // O LabelManager já foi inicializado no construtor como singleton
        // e já registrou seu próprio listener
        System.out.println("[DefaultLabel] ✓ Plugin inicializado com sucesso!");
        System.out.println("[DefaultLabel] ========================================");
    }
    
    @Override
    public void stop(BundleContext context) throws Exception {
        // O listener agora está registrado no LabelManager
        super.stop(context);
    }
    
    public LabelManager getLabelManager() {
        return labelManager;
    }
}

