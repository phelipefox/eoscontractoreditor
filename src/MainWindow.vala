public class EOSContractEditor.MainWindow : Gtk.ApplicationWindow {
    private enum Columns {
        TEXT,
        N_COLUMNS
    }

    private string directory_path;
    private string item;

    private Gtk.Stack stack;
    private Gtk.Box vbox_create_page;
    private Gtk.Box vbox_list_page;
    private Gtk.Box vbox_edit_page;
    private Gtk.ListStore list_store;
    private Gtk.TreeView tree_view;
    private GLib.List<string> list;
    private Gtk.Entry entry_name;
    private Gtk.Entry entry_exec;
    private Gtk.Entry entry_icon;
    private Gtk.Entry entry_MimeType;
    private Gtk.Entry entry_description;
    private Gtk.TextView text_view;
    private Gtk.Button back_button_list_page;
    private Gtk.Button back_button_edit_page;
    private Gtk.Button delete_button;
    private Gtk.Button edit_button;
    private Gtk.Button save_button;
    private Gtk.Button clear_button;

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            title: "EOS Contractor Editor",
            window_position: Gtk.WindowPosition.CENTER,
            resizable: false,
            height_request: 580,
            width_request: 580,
            border_width: 10
        );
    }

    construct {
        back_button_list_page = new Gtk.Button () {
            vexpand = false,
            image = new Gtk.Image.from_icon_name ("go-previous", Gtk.IconSize.SMALL_TOOLBAR),
            tooltip_text = "Back"
        };

        back_button_edit_page = new Gtk.Button () {
            vexpand = false,
            image = new Gtk.Image.from_icon_name ("go-previous", Gtk.IconSize.SMALL_TOOLBAR),
            tooltip_text = "Back"
        };

        delete_button = new Gtk.Button () {
            vexpand = false,
            image = new Gtk.Image.from_icon_name ("edit-delete", Gtk.IconSize.SMALL_TOOLBAR),
            tooltip_text = "Delete"
        };

        edit_button = new Gtk.Button () {
            vexpand = false,
            image = new Gtk.Image.from_icon_name ("edit", Gtk.IconSize.SMALL_TOOLBAR),
            tooltip_text = "Edit"
        };

        save_button = new Gtk.Button () {
            vexpand = false,
            image = new Gtk.Image.from_icon_name ("document-save", Gtk.IconSize.SMALL_TOOLBAR),
            tooltip_text = "Save"
        };

        clear_button = new Gtk.Button () {
            vexpand = false,
            image = new Gtk.Image.from_icon_name ("edit-clear", Gtk.IconSize.SMALL_TOOLBAR),
            tooltip_text = "Clear"
        };

        var headerbar = new Gtk.HeaderBar () {
            show_close_button = true
        };
        headerbar.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        headerbar.add (back_button_list_page);
        headerbar.add (edit_button);
        headerbar.add (delete_button);
        headerbar.add (back_button_edit_page);
        headerbar.add (save_button);
        headerbar.add (clear_button);
        set_titlebar (headerbar);

        back_button_list_page.clicked.connect (go_to_create_page);
        delete_button.clicked.connect (on_delete_clicked);
        edit_button.clicked.connect (on_edit_clicked);
        back_button_edit_page.clicked.connect (go_to_list_page_from_edit_page);
        save_button.clicked.connect (on_save_clicked);
        clear_button.clicked.connect (on_clear_clicked);

        set_buttons_on_create_page ();

        entry_name = new Gtk.Entry ();
        entry_name.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        entry_name.icon_press.connect ((pos, event) => {
            if (pos == Gtk.EntryIconPosition.SECONDARY) {
                entry_name.text = "";
            }
        });

        var label_name = new Gtk.Label.with_mnemonic ("_Name:                                                                 (Name that will be displayed in the menu)");
        label_name.set_xalign(0);
        
        var vbox_name = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        vbox_name.pack_start (label_name, false, true, 0);
        vbox_name.pack_start (entry_name, true, true, 0);

        entry_exec = new Gtk.Entry ();
        entry_exec.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "document-open-symbolic");
        entry_exec.icon_press.connect ((pos, event) => {
            if (pos == Gtk.EntryIconPosition.SECONDARY) {
                on_open_exec ();
            }
        });

        var label_exec = new Gtk.Label.with_mnemonic ("_Exec:                                                                                  (Command that will be executed)");
        label_exec.set_xalign(0);
        
        var vbox_exec = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        vbox_exec.pack_start (label_exec, false, true, 0);
        vbox_exec.pack_start (entry_exec, true, true, 0);

        entry_icon = new Gtk.Entry ();
        entry_icon.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "document-open-symbolic");
        entry_icon.icon_press.connect ((pos, event) => {
            if (pos == Gtk.EntryIconPosition.SECONDARY) {
                on_open_icon ();
            }
        });

        var label_icon = new Gtk.Label.with_mnemonic ("_Icon:                                     (The icon to be displayed in the menu. May not be visible.)");
        label_icon.set_xalign(0);
        
        var vbox_icon = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        vbox_icon.pack_start (label_icon, false, true, 0);
        vbox_icon.pack_start (entry_icon, true, true, 0);

        entry_MimeType = new Gtk.Entry ();
        entry_MimeType.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        entry_MimeType.icon_press.connect ((pos, event) => {
            if (pos == Gtk.EntryIconPosition.SECONDARY) {
                entry_MimeType.text = "";
            }
        });

        var label_MimeType = new Gtk.Label.with_mnemonic ("_MimeType:                (The types of files in which the custom menu will be displayed.)");
        label_MimeType.set_xalign(0);
        
        var vbox_MimeType = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        vbox_MimeType.pack_start (label_MimeType, false, true, 0);
        vbox_MimeType.pack_start (entry_MimeType, true, true, 0);

        entry_description = new Gtk.Entry ();
        entry_description.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        entry_description.icon_press.connect ((pos, event) => {
            if (pos == Gtk.EntryIconPosition.SECONDARY) {
                entry_description.text = "";
            }
        });

        var label_description = new Gtk.Label.with_mnemonic ("_Description:");
        label_description.set_xalign(0);
        
        var vbox_description = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        vbox_description.pack_start (label_description, false, true, 0);
        vbox_description.pack_start (entry_description, true, true, 0);

        var button_create = new Gtk.Button.with_label ("Creates the context menu with the above information");
        button_create.clicked.connect (on_create_file);

        var button_edit = new Gtk.Button.with_label ("Manage your context menus");
        button_edit.clicked.connect (go_to_list_page_from_create_page);

        vbox_create_page = new Gtk.Box (Gtk.Orientation.VERTICAL,20);
        vbox_create_page.pack_start (vbox_name, false, true, 0);
        vbox_create_page.pack_start (vbox_exec, false, true, 0);
        vbox_create_page.pack_start (vbox_icon, false, true, 0);
        vbox_create_page.pack_start (vbox_MimeType, false, true, 0);
        vbox_create_page.pack_start (vbox_description, false, true, 0);
        vbox_create_page.pack_start (button_create, true, false, 0);
        vbox_create_page.pack_start (button_edit, true, false, 0);

        var text = new Gtk.CellRendererText ();

        var column = new Gtk.TreeViewColumn ();
        column.pack_start (text, true);
        column.add_attribute (text, "markup", Columns.TEXT);

        list_store = new Gtk.ListStore (Columns.N_COLUMNS, typeof (string));
        tree_view = new Gtk.TreeView.with_model (list_store) {
            headers_visible = false
        };
        tree_view.append_column (column);
        tree_view.cursor_changed.connect (on_select_item);

        var scroll_list_page = new Gtk.ScrolledWindow (null, null);
        scroll_list_page.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        scroll_list_page.add (tree_view);

        vbox_list_page = new Gtk.Box (Gtk.Orientation.VERTICAL,20);
        vbox_list_page.pack_start (scroll_list_page, true, true, 0);


        text_view = new Gtk.TextView () {
            editable = true,
            cursor_visible = true,
            wrap_mode = Gtk.WrapMode.WORD
        };

        var scroll_edit_page = new Gtk.ScrolledWindow (null, null);
        scroll_edit_page.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        scroll_edit_page.add (text_view);

        vbox_edit_page = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        vbox_edit_page.pack_start (scroll_edit_page, true, true, 0);

        stack = new Gtk.Stack () {
            transition_duration = 600,
            transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT
        };
        stack.add (vbox_create_page);
        stack.add (vbox_list_page);
        stack.add (vbox_edit_page);
        stack.visible_child = vbox_create_page;
        add (stack);

        directory_path = Environment.get_home_dir () + "/.local/share/contractor";
        GLib.File file = GLib.File.new_for_path (directory_path);
        if (!file.query_exists ()) {
            alert ("Error!\nPath " + directory_path + " is not exists!\nYou must manually create the directory to store your context menu entries!");
            button_create.sensitive = false;
            button_edit.sensitive = false;
        }
    }

    private void on_open_exec () {
        var file_chooser = new Gtk.FileChooserDialog ("Open Exec", this, Gtk.FileChooserAction.OPEN, "_Cancel", Gtk.ResponseType.CANCEL, "_Open", Gtk.ResponseType.ACCEPT);
        if (file_chooser.run () == Gtk.ResponseType.ACCEPT) {
            entry_exec.text = file_chooser.get_filename ();
        }

        file_chooser.destroy ();
    }

    private void on_open_icon () {
        var file_chooser = new Gtk.FileChooserDialog ("Open Icon", this, Gtk.FileChooserAction.OPEN, "_Cancel", Gtk.ResponseType.CANCEL, "_Open", Gtk.ResponseType.ACCEPT);
        Gtk.FileFilter filter = new Gtk.FileFilter ();
        		file_chooser.set_filter (filter);
        		filter.add_mime_type ("image/jpeg");
                filter.add_mime_type ("image/png");
                Gtk.Image preview_area = new Gtk.Image ();
        		file_chooser.set_preview_widget (preview_area);
        		file_chooser.update_preview.connect (() => {
        			string uri = file_chooser.get_preview_uri ();
        			string path = file_chooser.get_preview_filename();
        			if (uri != null && uri.has_prefix ("file://") == true) {
        				try {
        					Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_file_at_scale (path, 250, 250, true);
        					preview_area.set_from_pixbuf (pixbuf);
        					preview_area.show ();
        				} catch (Error e) {
        					preview_area.hide ();
        				}
        			} else {
        				preview_area.hide ();
        			}
        		});
        if (file_chooser.run () == Gtk.ResponseType.ACCEPT) {
            entry_icon.text = file_chooser.get_filename ();
        }

        file_chooser.destroy ();
    }

    private void on_create_file () {
        if (is_empty (entry_name.text)) {
            alert ("Enter the name");
            entry_name.grab_focus ();
            return;
        }

        GLib.File file = GLib.File.new_for_path (directory_path + "/" + entry_name.text.strip () + ".contract");
        if (file.query_exists ()) {
            alert ("A file with the same name already exists");
            entry_name.grab_focus ();
            return;
        }

        var dialog_create_contractor_file = new Gtk.MessageDialog (this, Gtk.DialogFlags.MODAL, Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Create file " + file.get_basename () + " ?") {
            title = "Question"
        };
        Gtk.ResponseType result = (Gtk.ResponseType)dialog_create_contractor_file.run ();
        dialog_create_contractor_file.destroy ();
        if (result == Gtk.ResponseType.OK) {
            create_contractor_file ();
        }
    }

    private void on_edit_clicked () {
        var selection = tree_view.get_selection ();
        selection.set_mode (Gtk.SelectionMode.SINGLE);

        Gtk.TreeModel model;
        Gtk.TreeIter iter;
        if (!selection.get_selected (out model, out iter)) {
            alert ("Choose a file");
            return;
        }

        stack.visible_child = vbox_edit_page;
        set_buttons_on_edit_page ();
        string text;
        try {
            FileUtils.get_contents (directory_path + "/" + item, out text);
            text_view.buffer.text = text;
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }

    private void go_to_create_page () {
        stack.visible_child = vbox_create_page;
        set_buttons_on_create_page ();
    }

    private void go_to_list_page_from_create_page () {
        stack.visible_child = vbox_list_page;
        set_buttons_on_list_page ();
        show_desktop_files ();
    }

    private void go_to_list_page_from_edit_page () {
        stack.visible_child = vbox_list_page;
        set_buttons_on_list_page ();
    }

    private void on_save_clicked () {
        if (is_empty (text_view.buffer.text)) {
            alert ("Nothing to save");
            return;
        }

        GLib.File file = GLib.File.new_for_path (directory_path + "/" + item);
        var dialog_save_file = new Gtk.MessageDialog (this, Gtk.DialogFlags.MODAL, Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Save file " + file.get_basename () + " ?") {
            title = "Question"
        };
        Gtk.ResponseType result = (Gtk.ResponseType)dialog_save_file.run ();
        if (result == Gtk.ResponseType.OK) {
            try {
                FileUtils.set_contents (file.get_path (), text_view.buffer.text);
            } catch (Error e) {
                stderr.printf ("Error: %s\n", e.message);
            }
        }

        dialog_save_file.destroy ();
    }

    private void on_delete_clicked () {
        var selection = tree_view.get_selection ();
        selection.set_mode (Gtk.SelectionMode.SINGLE);

        Gtk.TreeModel model;
        Gtk.TreeIter iter;
        if (!selection.get_selected (out model, out iter)) {
            alert ("Choose a file");
            return;
        }

        GLib.File file = GLib.File.new_for_path (directory_path + "/" + item);
        var dialog_delete_file = new Gtk.MessageDialog (this, Gtk.DialogFlags.MODAL, Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Delete file " + file.get_basename () + " ?") {
            title = "Question"
        };
        Gtk.ResponseType result = (Gtk.ResponseType)dialog_delete_file.run ();
        dialog_delete_file.destroy ();
        if (result == Gtk.ResponseType.OK) {
            FileUtils.remove (directory_path + "/" + item);
            if (file.query_exists ()) {
                alert ("Delete failed");
            } else {
                show_desktop_files ();
                text_view.buffer.text = "";
            }
        }
    }

    private void on_clear_clicked () {
        if (is_empty (text_view.buffer.text)) {
            alert ("Nothing to clear");
            return;
        }

        var dialog_clear_file = new Gtk.MessageDialog (this, Gtk.DialogFlags.MODAL, Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Clear editor?") {
            title = "Question"
        };
        Gtk.ResponseType result = (Gtk.ResponseType)dialog_clear_file.run ();
        if (result == Gtk.ResponseType.OK) {
            text_view.buffer.text = "";
        }

        dialog_clear_file.destroy ();
    }

    private void on_select_item () {
        var selection = tree_view.get_selection ();
        selection.set_mode (Gtk.SelectionMode.SINGLE);

        Gtk.TreeModel model;
        Gtk.TreeIter iter;
        if (!selection.get_selected (out model, out iter)) {
            return;
        }

        Gtk.TreePath path = model.get_path (iter);
        var index = int.parse (path.to_string ());
        if (index >= 0) {
            item = list.nth_data (index);
        }
    }

    private void create_contractor_file () {

        string desktop_file = "[Contractor Entry]
Encoding=UTF-8
X-GNOME-Gettext-Domain=pantheon-desktop-plug
Exec=" + entry_exec.text.strip () + "
Icon=" + entry_icon.text.strip () + "
Name=" + entry_name.text.strip () + "
Description=" + entry_description.text.strip () + "
MimeType=" + entry_MimeType.text.strip ();
        string path = directory_path + "/" + entry_name.text + ".contract";
        try {
            FileUtils.set_contents (path, desktop_file);
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }

        GLib.File file = GLib.File.new_for_path (path);
        if (file.query_exists ()) {
            alert ("File " + file.get_basename () + " is created!\nPath: " + path);
        } else {
            alert ("Error! Could not create file");
        }
    }

    private bool is_empty (string str) {
        return str.strip ().length == 0;
    }

    private void show_desktop_files () {
        list_store.clear ();
        list = new GLib.List<string> ();
        try {
            Dir dir = Dir.open (directory_path, 0);
            string? name = null;
            while ((name = dir.read_name ()) != null) {
                list.append (name);
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }

        Gtk.TreeIter iter;
        foreach (string item in list) {
            list_store.append (out iter);
            list_store.set (iter, Columns.TEXT, item);
        }
    }

    private void set_widget_visible (Gtk.Widget widget, bool visible) {
        widget.no_show_all = !visible;
        widget.visible = visible;
    }

    private void set_buttons_on_edit_page () {
        set_widget_visible (back_button_list_page, false);
        set_widget_visible (back_button_edit_page, true);
        set_widget_visible (save_button, true);
        set_widget_visible (delete_button, false);
        set_widget_visible (edit_button, false);
        set_widget_visible (clear_button, true);
    }

    private void set_buttons_on_list_page () {
        set_widget_visible (back_button_list_page, true);
        set_widget_visible (back_button_edit_page, false);
        set_widget_visible (save_button, false);
        set_widget_visible (delete_button, true);
        set_widget_visible (edit_button, true);
        set_widget_visible (clear_button, false);
    }

    private void set_buttons_on_create_page () {
        set_widget_visible (back_button_list_page, false);
        set_widget_visible (back_button_edit_page, false);
        set_widget_visible (save_button, false);
        set_widget_visible (delete_button, false);
        set_widget_visible (edit_button, false);
        set_widget_visible (clear_button, false);
    }

    private void alert (string str) {
        var dialog_alert = new Gtk.MessageDialog (this, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, str) {
            title = "Message"
        };
        dialog_alert.run ();
        dialog_alert.destroy ();
    }
}
