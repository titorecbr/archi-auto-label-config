package com.vhsystem.defaultlabel;

import org.eclipse.core.runtime.Platform;
import org.eclipse.ui.IStartup;
import org.osgi.framework.Bundle;
import org.osgi.framework.BundleException;

/**
 * Startup handler that forces plugin initialization when Archi starts.
 * This ensures that LabelManager is loaded and default labels are
 * recognized even before opening the configuration dialog.
 */
public class StartupHandler implements IStartup {
    
    @Override
    public void earlyStartup() {
        System.out.println("[DefaultLabel] ========================================");
        System.out.println("[DefaultLabel] 🚀 StartupHandler.earlyStartup() called!");
        System.out.println("[DefaultLabel] Forcing plugin initialization...");
        
        try {
            // Try to force bundle activation
            Bundle bundle = Platform.getBundle("com.vhsystem.defaultlabel");
            if (bundle != null) {
                System.out.println("[DefaultLabel] Bundle found, state: " + getBundleStateName(bundle.getState()));
                
                // If bundle is not active, try to start it
                if (bundle.getState() != Bundle.ACTIVE) {
                    System.out.println("[DefaultLabel] Starting bundle...");
                    bundle.start();
                    System.out.println("[DefaultLabel] ✓ Bundle started!");
                }
                
                // Wait a bit to ensure plugin was initialized
                Thread.sleep(100);
                
                // Access plugin to force its activation
                DefaultLabelPlugin plugin = DefaultLabelPlugin.getDefault();
                
                if (plugin != null) {
                    System.out.println("[DefaultLabel] ✓ Plugin initialized successfully!");
                    
                    // Check if LabelManager was loaded
                    LabelManager labelManager = plugin.getLabelManager();
                    if (labelManager != null) {
                        System.out.println("[DefaultLabel] ✓ LabelManager loaded and ready!");
                    } else {
                        System.err.println("[DefaultLabel] ❌ ERROR: LabelManager is null!");
                    }
                } else {
                    System.err.println("[DefaultLabel] ❌ ERROR: Plugin was not initialized!");
                }
            } else {
                System.err.println("[DefaultLabel] ❌ ERROR: Bundle not found!");
            }
        } catch (BundleException e) {
            System.err.println("[DefaultLabel] ❌ ERROR starting bundle: " + e.getMessage());
            e.printStackTrace();
        } catch (InterruptedException e) {
            System.err.println("[DefaultLabel] ❌ ERROR: Thread interrupted");
        }
        
        System.out.println("[DefaultLabel] ========================================");
    }
    
    private String getBundleStateName(int state) {
        switch (state) {
            case Bundle.UNINSTALLED: return "UNINSTALLED";
            case Bundle.INSTALLED: return "INSTALLED";
            case Bundle.RESOLVED: return "RESOLVED";
            case Bundle.STARTING: return "STARTING";
            case Bundle.STOPPING: return "STOPPING";
            case Bundle.ACTIVE: return "ACTIVE";
            default: return "UNKNOWN(" + state + ")";
        }
    }
}

