package com.vhsystem.defaultlabel.dialogs;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import org.eclipse.jface.dialogs.Dialog;
import org.eclipse.jface.dialogs.IDialogConstants;
import org.eclipse.jface.viewers.ArrayContentProvider;
import org.eclipse.jface.viewers.CellEditor;
import org.eclipse.jface.viewers.ColumnLabelProvider;
import org.eclipse.jface.viewers.EditingSupport;
import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.jface.viewers.TableViewerColumn;
import org.eclipse.jface.viewers.TextCellEditor;
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;

import com.archimatetool.model.IArchimateElement;
import com.vhsystem.defaultlabel.LabelManager;

/**
 * Dialog to manage default labels
 */
public class ManageLabelsDialog extends Dialog {
    
    private LabelManager labelManager;
    private TableViewer viewer;
    private List<LabelEntry> entries;
    
    public ManageLabelsDialog(Shell parentShell, LabelManager labelManager) {
        super(parentShell);
        this.labelManager = labelManager;
        setShellStyle(SWT.DIALOG_TRIM | SWT.RESIZE | SWT.MAX);
    }
    
    @Override
    protected void configureShell(Shell newShell) {
        super.configureShell(newShell);
        newShell.setText("Manage Default Labels");
        newShell.setSize(600, 500);
    }
    
    @Override
    protected Control createDialogArea(Composite parent) {
        Composite container = (Composite) super.createDialogArea(parent);
        GridLayout layout = new GridLayout(1, false);
        layout.marginWidth = 10;
        layout.marginHeight = 10;
        container.setLayout(layout);
        
        // Instruction label
        Label instructionLabel = new Label(container, SWT.WRAP);
        instructionLabel.setText("Configure default labels that will be automatically applied when new elements are created:");
        GridData gd = new GridData(SWT.FILL, SWT.CENTER, true, false);
        gd.widthHint = 550;
        instructionLabel.setLayoutData(gd);
        
        // Table
        Table table = new Table(container, SWT.BORDER | SWT.FULL_SELECTION | SWT.MULTI);
        table.setHeaderVisible(true);
        table.setLinesVisible(true);
        gd = new GridData(SWT.FILL, SWT.FILL, true, true);
        gd.heightHint = 350;
        table.setLayoutData(gd);
        
        viewer = new TableViewer(table);
        
        // Element Type Column
        TableViewerColumn typeColumn = new TableViewerColumn(viewer, SWT.NONE);
        typeColumn.getColumn().setWidth(300);
        typeColumn.getColumn().setText("Element Type");
        typeColumn.setLabelProvider(new ColumnLabelProvider() {
            @Override
            public String getText(Object element) {
                LabelEntry entry = (LabelEntry) element;
                return entry.getTypeName();
            }
        });
        
        // Default Label Column (editable)
        TableViewerColumn labelColumn = new TableViewerColumn(viewer, SWT.NONE);
        labelColumn.getColumn().setWidth(250);
        labelColumn.getColumn().setText("Default Label");
        labelColumn.setLabelProvider(new ColumnLabelProvider() {
            @Override
            public String getText(Object element) {
                LabelEntry entry = (LabelEntry) element;
                return entry.getLabel() != null ? entry.getLabel() : "";
            }
        });
        
        // Editing support
        labelColumn.setEditingSupport(new EditingSupport(viewer) {
            @Override
            protected boolean canEdit(Object element) {
                return true;
            }
            
            @Override
            protected CellEditor getCellEditor(Object element) {
                return new TextCellEditor(viewer.getTable());
            }
            
            @Override
            protected Object getValue(Object element) {
                LabelEntry entry = (LabelEntry) element;
                return entry.getLabel() != null ? entry.getLabel() : "";
            }
            
            @Override
            protected void setValue(Object element, Object value) {
                LabelEntry entry = (LabelEntry) element;
                String newLabel = value.toString().trim();
                entry.setLabel(newLabel.isEmpty() ? null : newLabel);
                labelManager.setDefaultLabel(entry.getElementClass(), entry.getLabel());
                viewer.update(element, null);
            }
        });
        
        // Load data
        loadEntries();
        viewer.setContentProvider(new ArrayContentProvider());
        viewer.setInput(entries);
        
        return container;
    }
    
    private void loadEntries() {
        entries = new ArrayList<>();
        Map<Class<?>, String> allLabels = labelManager.getAllDefaultLabels();
        
        // Get all known ArchiMate element classes
        List<Class<? extends IArchimateElement>> elementClasses = getAllElementClasses();
        
        for (Class<? extends IArchimateElement> clazz : elementClasses) {
            String label = allLabels.get(clazz);
            entries.add(new LabelEntry(clazz, label));
        }
        
        // Sort by type name
        Collections.sort(entries, new Comparator<LabelEntry>() {
            @Override
            public int compare(LabelEntry e1, LabelEntry e2) {
                return e1.getTypeName().compareToIgnoreCase(e2.getTypeName());
            }
        });
    }
    
    @SuppressWarnings("unchecked")
    private List<Class<? extends IArchimateElement>> getAllElementClasses() {
        List<Class<? extends IArchimateElement>> classes = new ArrayList<>();
        
        // Application Layer
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IApplicationComponent.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IApplicationCollaboration.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IApplicationInterface.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IApplicationFunction.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IApplicationInteraction.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IApplicationProcess.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IApplicationService.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IApplicationEvent.class);
        
        // Business Layer
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IBusinessActor.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IBusinessCollaboration.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IBusinessEvent.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IBusinessFunction.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IBusinessInteraction.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IBusinessInterface.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IBusinessObject.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IBusinessProcess.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IBusinessRole.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IBusinessService.class);
        
        // Technology Layer
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IArtifact.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ITechnologyCollaboration.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IDevice.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ITechnologyEvent.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ITechnologyFunction.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ITechnologyInteraction.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ITechnologyInterface.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ICommunicationNetwork.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IDistributionNetwork.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.INode.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ITechnologyObject.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ITechnologyProcess.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ITechnologyService.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ISystemSoftware.class);
        
        // Physical Layer
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ILocation.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IPath.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IEquipment.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IFacility.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IMaterial.class);
        
        // Data Layer
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IDataObject.class);
        
        // Strategy Layer
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IResource.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ICapability.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.ICourseOfAction.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IValueStream.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IProduct.class);
        
        // Motivation Layer
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IStakeholder.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IDriver.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IAssessment.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IGoal.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IOutcome.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IPrinciple.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IRequirement.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IConstraint.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IMeaning.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IValue.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IRepresentation.class);
        
        // Implementation & Migration Layer
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IWorkPackage.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IDeliverable.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IImplementationEvent.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IPlateau.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IGap.class);
        
        // Other Elements
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IJunction.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IGrouping.class);
        classes.add((Class<? extends IArchimateElement>) com.archimatetool.model.IContract.class);
        
        return classes;
    }
    
    @Override
    protected void createButtonsForButtonBar(Composite parent) {
        createButton(parent, IDialogConstants.OK_ID, IDialogConstants.OK_LABEL, true);
    }
    
    @Override
    protected Point getInitialSize() {
        return new Point(600, 500);
    }
    
    /**
     * Helper class to represent a label entry
     */
    private static class LabelEntry {
        private Class<?> elementClass;
        private String label;
        
        public LabelEntry(Class<?> elementClass, String label) {
            this.elementClass = elementClass;
            this.label = label;
        }
        
        public Class<?> getElementClass() {
            return elementClass;
        }
        
        public String getLabel() {
            return label;
        }
        
        public void setLabel(String label) {
            this.label = label;
        }
        
        public String getTypeName() {
            return LabelManager.getFriendlyClassName(elementClass);
        }
    }
}

