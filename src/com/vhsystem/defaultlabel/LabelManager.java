package com.vhsystem.defaultlabel;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Platform;

import com.archimatetool.model.IArchimateElement;
import com.archimatetool.model.IArchimateRelationship;
import com.archimatetool.model.IAccessRelationship;
import com.archimatetool.model.IAggregationRelationship;
import com.archimatetool.model.IAssignmentRelationship;
import com.archimatetool.model.IAssociationRelationship;
import com.archimatetool.model.ICompositionRelationship;
import com.archimatetool.model.IFlowRelationship;
import com.archimatetool.model.IInfluenceRelationship;
import com.archimatetool.model.IRealizationRelationship;
import com.archimatetool.model.IServingRelationship;
import com.archimatetool.model.ISpecializationRelationship;
import com.archimatetool.model.ITriggeringRelationship;
import com.archimatetool.model.IApplicationComponent;
import com.archimatetool.model.IApplicationCollaboration;
import com.archimatetool.model.IApplicationInterface;
import com.archimatetool.model.IApplicationFunction;
import com.archimatetool.model.IApplicationInteraction;
import com.archimatetool.model.IApplicationProcess;
import com.archimatetool.model.IApplicationService;
import com.archimatetool.model.IBusinessActor;
import com.archimatetool.model.IBusinessCollaboration;
import com.archimatetool.model.IBusinessEvent;
import com.archimatetool.model.IBusinessFunction;
import com.archimatetool.model.IBusinessInteraction;
import com.archimatetool.model.IBusinessInterface;
import com.archimatetool.model.IBusinessObject;
import com.archimatetool.model.IBusinessProcess;
import com.archimatetool.model.IBusinessRole;
import com.archimatetool.model.IBusinessService;
import com.archimatetool.model.IDataObject;
import com.archimatetool.model.ITechnologyCollaboration;
import com.archimatetool.model.ITechnologyEvent;
import com.archimatetool.model.ITechnologyFunction;
import com.archimatetool.model.ITechnologyInteraction;
import com.archimatetool.model.ITechnologyInterface;
import com.archimatetool.model.ITechnologyObject;
import com.archimatetool.model.ITechnologyProcess;
import com.archimatetool.model.ITechnologyService;
import com.archimatetool.model.IArtifact;
import com.archimatetool.model.IDevice;
import com.archimatetool.model.ICommunicationNetwork;
import com.archimatetool.model.IDistributionNetwork;
import com.archimatetool.model.INode;
import com.archimatetool.model.ILocation;
import com.archimatetool.model.IEquipment;
import com.archimatetool.model.IFacility;
import com.archimatetool.model.IMaterial;
import com.archimatetool.model.IJunction;
import com.archimatetool.model.IGrouping;
// Strategy Layer
import com.archimatetool.model.IResource;
import com.archimatetool.model.ICapability;
import com.archimatetool.model.ICourseOfAction;
import com.archimatetool.model.IValueStream;
import com.archimatetool.model.IProduct;
// Motivation Layer
import com.archimatetool.model.IStakeholder;
import com.archimatetool.model.IDriver;
import com.archimatetool.model.IAssessment;
import com.archimatetool.model.IGoal;
import com.archimatetool.model.IOutcome;
import com.archimatetool.model.IPrinciple;
import com.archimatetool.model.IRequirement;
import com.archimatetool.model.IConstraint;
import com.archimatetool.model.IMeaning;
import com.archimatetool.model.IValue;
// Implementation & Migration Layer
import com.archimatetool.model.IWorkPackage;
import com.archimatetool.model.IDeliverable;
import com.archimatetool.model.IImplementationEvent;
import com.archimatetool.model.IPlateau;
import com.archimatetool.model.IGap;
// Other Layer
import com.archimatetool.model.IContract;
import com.archimatetool.model.IRepresentation;
import com.archimatetool.model.ISystemSoftware;
import com.archimatetool.model.IApplicationEvent;

/**
 * Gerenciador de labels padrão
 */
public class LabelManager {
    
    private static final String CONFIG_FILE = "default_labels.properties";
    
    private Map<Class<?>, String> defaultLabels;
    private File configFile;
    
    public LabelManager() {
        defaultLabels = new HashMap<>();
        loadConfiguration();
    }
    
    /**
     * Obtém o label padrão para um tipo de elemento
     * Busca pela classe e por todas as interfaces que ela implementa
     */
    public String getDefaultLabel(Class<?> elementClass) {
        System.out.println("[LabelManager] Buscando label para: " + elementClass.getName());
        System.out.println("[LabelManager] Total de labels configurados: " + defaultLabels.size());
        
        // Primeiro tenta pela classe direta
        String label = defaultLabels.get(elementClass);
        if (label != null) {
            System.out.println("[LabelManager] ✓ Label encontrado pela classe direta: '" + label + "'");
            return label;
        }
        
        // Se não encontrou, busca pelas interfaces que a classe implementa
        System.out.println("[LabelManager] Buscando pelas interfaces...");
        for (Class<?> interfaceClass : elementClass.getInterfaces()) {
            System.out.println("[LabelManager]   Testando: " + interfaceClass.getName());
            label = defaultLabels.get(interfaceClass);
            if (label != null) {
                System.out.println("[LabelManager] ✓ Label encontrado pela interface: " + interfaceClass.getSimpleName() + " = '" + label + "'");
                return label;
            }
        }
        
        // Busca nas superclasses também
        Class<?> superClass = elementClass.getSuperclass();
        if (superClass != null && superClass != Object.class) {
            System.out.println("[LabelManager] Buscando na superclasse: " + superClass.getName());
            label = getDefaultLabel(superClass);
            if (label != null) {
                return label;
            }
        }
        
        System.out.println("[LabelManager] ❌ Nenhum label encontrado para esta classe");
        return null;
    }
    
    /**
     * Define o label padrão para um tipo de elemento
     */
    public void setDefaultLabel(Class<?> elementClass, String label) {
        if (label == null || label.trim().isEmpty()) {
            defaultLabels.remove(elementClass);
        } else {
            defaultLabels.put(elementClass, label);
        }
        saveConfiguration();
    }
    
    /**
     * Obtém todos os labels padrão
     */
    public Map<Class<?>, String> getAllDefaultLabels() {
        return new HashMap<>(defaultLabels);
    }
    
    /**
     * Carrega configuração do arquivo
     */
    private void loadConfiguration() {
        configFile = getConfigFile();
        
        // Sempre inicializa com todos os defaults primeiro
        initializeDefaultLabels();
        
        // Se o arquivo existe, sobrescreve com as configurações personalizadas do usuário
        if (configFile.exists()) {
            Properties props = new Properties();
            try (FileInputStream fis = new FileInputStream(configFile)) {
                props.load(fis);
                
                for (String key : props.stringPropertyNames()) {
                    try {
                        Class<?> clazz = Class.forName(key);
                        String label = props.getProperty(key);
                        defaultLabels.put(clazz, label);
                    } catch (ClassNotFoundException e) {
                        // Ignora classes que não existem mais
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        
        // Sempre salva para garantir que novos elementos sejam persistidos
        saveConfiguration();
    }
    
    /**
     * Salva configuração no arquivo
     */
    private void saveConfiguration() {
        Properties props = new Properties();
        
        for (Map.Entry<Class<?>, String> entry : defaultLabels.entrySet()) {
            props.setProperty(entry.getKey().getName(), entry.getValue());
        }
        
        try (FileOutputStream fos = new FileOutputStream(configFile)) {
            props.store(fos, "Default Labels Configuration");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Inicializa labels padrão com valores sugeridos
     */
    private void initializeDefaultLabels() {
        System.out.println("[LabelManager] Inicializando labels padrão...");
        
        // Application Layer (8 elementos)
        defaultLabels.put(IApplicationComponent.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IApplicationCollaboration.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IApplicationInterface.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IApplicationFunction.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IApplicationInteraction.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IApplicationProcess.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IApplicationService.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IApplicationEvent.class, "<<${specialization}>>\n${name}");
        
        // Business Layer (10 elementos)
        defaultLabels.put(IBusinessActor.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IBusinessCollaboration.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IBusinessEvent.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IBusinessFunction.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IBusinessInteraction.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IBusinessInterface.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IBusinessObject.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IBusinessProcess.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IBusinessRole.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IBusinessService.class, "<<${specialization}>>\n${name}");
        
        // Technology Layer (14 elementos)
        defaultLabels.put(IArtifact.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(ITechnologyCollaboration.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IDevice.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(ITechnologyEvent.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(ITechnologyFunction.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(ITechnologyInteraction.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(ITechnologyInterface.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(ICommunicationNetwork.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IDistributionNetwork.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(INode.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(ITechnologyObject.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(ITechnologyProcess.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(ITechnologyService.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(ISystemSoftware.class, "<<${specialization}>>\n${name}");
        
        // Physical Layer (5 elementos)
        defaultLabels.put(ILocation.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(com.archimatetool.model.IPath.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IEquipment.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IFacility.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IMaterial.class, "<<${specialization}>>\n${name}");
        
        // Data Layer (1 elemento)
        defaultLabels.put(IDataObject.class, "<<${specialization}>>\n${name}");
        
        // Relationships (11 elementos) - Geralmente não precisam de label, mas podem ter nome
        defaultLabels.put(IAccessRelationship.class, "${name}");
        defaultLabels.put(IAggregationRelationship.class, "${name}");
        defaultLabels.put(IAssignmentRelationship.class, "${name}");
        defaultLabels.put(IAssociationRelationship.class, "${name}");
        defaultLabels.put(ICompositionRelationship.class, "${name}");
        defaultLabels.put(IFlowRelationship.class, "${name}");
        defaultLabels.put(IInfluenceRelationship.class, "${name}");
        defaultLabels.put(IRealizationRelationship.class, "${name}");
        defaultLabels.put(IServingRelationship.class, "${name}");
        defaultLabels.put(ISpecializationRelationship.class, "${name}");
        defaultLabels.put(ITriggeringRelationship.class, "${name}");
        
        // Other Elements (3 elementos)
        defaultLabels.put(IJunction.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IGrouping.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IContract.class, "<<${specialization}>>\n${name}");
        
        // Strategy Layer (5 elementos)
        defaultLabels.put(IResource.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(ICapability.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(ICourseOfAction.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IValueStream.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IProduct.class, "<<${specialization}>>\n${name}");
        
        // Motivation Layer (11 elementos)
        defaultLabels.put(IStakeholder.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IDriver.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IAssessment.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IGoal.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IOutcome.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IPrinciple.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IRequirement.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IConstraint.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IMeaning.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IValue.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IRepresentation.class, "<<${specialization}>>\n${name}");
        
        // Implementation & Migration Layer (5 elementos)
        defaultLabels.put(IWorkPackage.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IDeliverable.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IImplementationEvent.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IPlateau.class, "<<${specialization}>>\n${name}");
        defaultLabels.put(IGap.class, "<<${specialization}>>\n${name}");
        
        System.out.println("[LabelManager] ✓ Labels inicializados: " + defaultLabels.size() + " tipos configurados");
    }
    
    /**
     * Obtém o arquivo de configuração
     */
    private File getConfigFile() {
        org.eclipse.core.runtime.IPath stateLocation = Platform.getStateLocation(
            DefaultLabelPlugin.getDefault().getBundle());
        return stateLocation.append(CONFIG_FILE).toFile();
    }
    
    /**
     * Obtém o nome amigável de uma classe
     */
    public static String getFriendlyClassName(Class<?> clazz) {
        String simpleName = clazz.getSimpleName();
        // Remove o prefixo "I" se existir
        if (simpleName.startsWith("I") && simpleName.length() > 1) {
            simpleName = simpleName.substring(1);
        }
        // Adiciona espaços antes de letras maiúsculas
        return simpleName.replaceAll("([A-Z])", " $1").trim();
    }
}

