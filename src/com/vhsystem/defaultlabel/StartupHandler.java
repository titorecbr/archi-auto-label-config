package com.vhsystem.defaultlabel;

import org.eclipse.core.runtime.Platform;
import org.eclipse.ui.IStartup;
import org.osgi.framework.Bundle;
import org.osgi.framework.BundleException;

/**
 * Handler de startup que força a inicialização do plugin quando o Archi inicia.
 * Isso garante que o LabelManager seja carregado e os labels padrão sejam
 * reconhecidos mesmo antes de abrir a dialog de configuração.
 */
public class StartupHandler implements IStartup {
    
    @Override
    public void earlyStartup() {
        System.out.println("[DefaultLabel] ========================================");
        System.out.println("[DefaultLabel] 🚀 StartupHandler.earlyStartup() chamado!");
        System.out.println("[DefaultLabel] Forçando inicialização do plugin...");
        
        try {
            // Tenta forçar a ativação do bundle
            Bundle bundle = Platform.getBundle("com.vhsystem.defaultlabel");
            if (bundle != null) {
                System.out.println("[DefaultLabel] Bundle encontrado, estado: " + getBundleStateName(bundle.getState()));
                
                // Se o bundle não está ativo, tenta iniciar
                if (bundle.getState() != Bundle.ACTIVE) {
                    System.out.println("[DefaultLabel] Iniciando bundle...");
                    bundle.start();
                    System.out.println("[DefaultLabel] ✓ Bundle iniciado!");
                }
                
                // Aguarda um pouco para garantir que o plugin foi inicializado
                Thread.sleep(100);
                
                // Acessa o plugin para forçar sua ativação
                DefaultLabelPlugin plugin = DefaultLabelPlugin.getDefault();
                
                if (plugin != null) {
                    System.out.println("[DefaultLabel] ✓ Plugin inicializado com sucesso!");
                    
                    // Verifica se o LabelManager foi carregado
                    LabelManager labelManager = plugin.getLabelManager();
                    if (labelManager != null) {
                        System.out.println("[DefaultLabel] ✓ LabelManager carregado e pronto!");
                    } else {
                        System.err.println("[DefaultLabel] ❌ ERRO: LabelManager é null!");
                    }
                } else {
                    System.err.println("[DefaultLabel] ❌ ERRO: Plugin não foi inicializado!");
                }
            } else {
                System.err.println("[DefaultLabel] ❌ ERRO: Bundle não encontrado!");
            }
        } catch (BundleException e) {
            System.err.println("[DefaultLabel] ❌ ERRO ao iniciar bundle: " + e.getMessage());
            e.printStackTrace();
        } catch (InterruptedException e) {
            System.err.println("[DefaultLabel] ❌ ERRO: Thread interrompida");
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

