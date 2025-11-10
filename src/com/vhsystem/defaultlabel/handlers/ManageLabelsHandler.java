package com.vhsystem.defaultlabel.handlers;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.ui.handlers.HandlerUtil;

import com.vhsystem.defaultlabel.DefaultLabelPlugin;
import com.vhsystem.defaultlabel.dialogs.ManageLabelsDialog;

/**
 * Handler para abrir o diálogo de gerenciamento de labels
 */
public class ManageLabelsHandler extends AbstractHandler {
    
    @Override
    public Object execute(ExecutionEvent event) throws ExecutionException {
        ManageLabelsDialog dialog = new ManageLabelsDialog(
            HandlerUtil.getActiveShell(event),
            DefaultLabelPlugin.getDefault().getLabelManager());
        dialog.open();
        return null;
    }
}

