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
        // Primeiro tenta pela classe direta
        String label = defaultLabels.get(elementClass);
        if (label != null) {
            return label;
        }
        
        // Se não encontrou, busca pelas interfaces que a classe implementa
        for (Class<?> interfaceClass : elementClass.getInterfaces()) {
            label = defaultLabels.get(interfaceClass);
            if (label != null) {
                System.out.println("[LabelManager] Label encontrado pela interface: " + interfaceClass.getSimpleName());
                return label;
            }
        }
        
        // Busca nas superclasses também
        Class<?> superClass = elementClass.getSuperclass();
        if (superClass != null && superClass != Object.class) {
            label = getDefaultLabel(superClass);
            if (label != null) {
                return label;
            }
        }
        
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
        
        if (!configFile.exists()) {
            initializeDefaultLabels();
            saveConfiguration();
            return;
        }
        
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
            initializeDefaultLabels();
        }
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
        // Application Layer
        defaultLabels.put(IApplicationComponent.class, "Componente");
        defaultLabels.put(IApplicationCollaboration.class, "Colaboração");
        defaultLabels.put(IApplicationInterface.class, "Interface");
        defaultLabels.put(IApplicationFunction.class, "Função");
        defaultLabels.put(IApplicationInteraction.class, "Interação");
        defaultLabels.put(IApplicationProcess.class, "Processo");
        defaultLabels.put(IApplicationService.class, "Serviço");
        
        // Business Layer
        defaultLabels.put(IBusinessActor.class, "Ator");
        defaultLabels.put(IBusinessCollaboration.class, "Colaboração");
        defaultLabels.put(IBusinessEvent.class, "Evento");
        defaultLabels.put(IBusinessFunction.class, "Função");
        defaultLabels.put(IBusinessInteraction.class, "Interação");
        defaultLabels.put(IBusinessInterface.class, "Interface");
        defaultLabels.put(IBusinessObject.class, "Objeto");
        defaultLabels.put(IBusinessProcess.class, "Processo");
        defaultLabels.put(IBusinessRole.class, "Papel");
        defaultLabels.put(IBusinessService.class, "Serviço");
        
        // Technology Layer
        defaultLabels.put(IArtifact.class, "Artefato");
        defaultLabels.put(ITechnologyCollaboration.class, "Colaboração");
        defaultLabels.put(IDevice.class, "Dispositivo");
        defaultLabels.put(ITechnologyEvent.class, "Evento");
        defaultLabels.put(ITechnologyFunction.class, "Função");
        defaultLabels.put(ITechnologyInteraction.class, "Interação");
        defaultLabels.put(ITechnologyInterface.class, "Interface");
        defaultLabels.put(ICommunicationNetwork.class, "Rede de Comunicação");
        defaultLabels.put(IDistributionNetwork.class, "Rede de Distribuição");
        defaultLabels.put(INode.class, "Nó");
        defaultLabels.put(ITechnologyObject.class, "Objeto Tecnológico");
        defaultLabels.put(ITechnologyProcess.class, "Processo");
        defaultLabels.put(ITechnologyService.class, "Serviço");
        
        // Physical Layer
        defaultLabels.put(ILocation.class, "Localização");
        defaultLabels.put(com.archimatetool.model.IPath.class, "Caminho");
        defaultLabels.put(IEquipment.class, "Equipamento");
        defaultLabels.put(IFacility.class, "Instalação");
        defaultLabels.put(IMaterial.class, "Material");
        
        // Data Layer
        defaultLabels.put(IDataObject.class, "Objeto de Dados");
        
        // Relationships
        defaultLabels.put(IAccessRelationship.class, "Acesso");
        defaultLabels.put(IAggregationRelationship.class, "Agregação");
        defaultLabels.put(IAssignmentRelationship.class, "Atribuição");
        defaultLabels.put(IAssociationRelationship.class, "Associação");
        defaultLabels.put(ICompositionRelationship.class, "Composição");
        defaultLabels.put(IFlowRelationship.class, "Fluxo");
        defaultLabels.put(IInfluenceRelationship.class, "Influência");
        defaultLabels.put(IRealizationRelationship.class, "Realização");
        defaultLabels.put(IServingRelationship.class, "Serviço");
        defaultLabels.put(ISpecializationRelationship.class, "Especialização");
        defaultLabels.put(ITriggeringRelationship.class, "Disparo");
        
        // Other Elements
        defaultLabels.put(IJunction.class, "Junção");
        defaultLabels.put(IGrouping.class, "Agrupamento");
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

