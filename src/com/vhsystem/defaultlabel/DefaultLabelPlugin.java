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
 * Main plugin to manage default labels in Archi
 */
public class DefaultLabelPlugin extends AbstractUIPlugin {
    
    public static final String PLUGIN_ID = "com.vhsystem.defaultlabel";
    
    private static DefaultLabelPlugin plugin;
    
    private LabelManager labelManager;
    private PropertyChangeListener modelListener;
    
    public DefaultLabelPlugin() {
        plugin = this;
        System.out.println("[DefaultLabel] ========================================");
        System.out.println("[DefaultLabel] 🚀 Plugin constructor called!");
        System.out.println("[DefaultLabel] Forcing LabelManager initialization...");
        // Force initialization of LabelManager singleton
        labelManager = LabelManager.getInstance();
        System.out.println("[DefaultLabel] ✓ LabelManager initialized!");
        System.out.println("[DefaultLabel] ========================================");
    }
    
    public static DefaultLabelPlugin getDefault() {
        return plugin;
    }
    
    @Override
    public void start(BundleContext context) throws Exception {
        System.out.println("[DefaultLabel] ========================================");
        System.out.println("[DefaultLabel] 🚀 Plugin.start() called!");
        System.out.println("[DefaultLabel] Starting plugin...");
        
        super.start(context);
        
        // LabelManager was already initialized in constructor as singleton
        // and has already registered its own listener
        System.out.println("[DefaultLabel] ✓ Plugin initialized successfully!");
        System.out.println("[DefaultLabel] ========================================");
    }
    
    @Override
    public void stop(BundleContext context) throws Exception {
        // Listener is now registered in LabelManager
        super.stop(context);
    }
    
    public LabelManager getLabelManager() {
        return labelManager;
    }
}

