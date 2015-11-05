require "java"
require "duse/desktop/clipboard"

module Duse
  module Desktop
    class ClipboardKeyListener
      def keyPressed(e)
        if e.isControlDown && e.getKeyChar != "c" && e.getKeyCode == 67
          secret = e.getSource.getLastSelectedPathComponent
          if !secret.nil?
            secret = secret.getUserObject
            user = Duse::User.current
            private_key = Duse.config.private_key_for user
            plaintext_secret = secret.decrypt(private_key)
            Clipboard.copy(plaintext_secret)
          end
        end
      end

      def keyTyped(e);end
      def keyReleased(e);end
    end

    class App
      def run
        frame = javax.swing.JFrame.new("Duse Desktop")
        frame.add(secret_tree)

        frame.setDefaultCloseOperation(javax.swing.JFrame::EXIT_ON_CLOSE)
        frame.pack
        frame.setVisible(true)
      end

      private

      def expand_all(tree)
        root = tree.getModel.getRoot
        expand(tree, javax.swing.tree.TreePath.new(root));
      end

      def expand(tree, parent)
        node = parent.getLastPathComponent
        if node.getChildCount >= 0
          node.children.each do |n|
            path = parent.pathByAddingChild(n)
            expand(tree, path)
          end
        end
        tree.expandPath(parent)
      end

      def secret_tree
        root_node = internal_node_tree
        jtree = javax.swing.JTree.new(root_node)
        expand_all(jtree)
        jtree.getSelectionModel.setSelectionMode(javax.swing.tree.TreeSelectionModel::SINGLE_TREE_SELECTION)
        jtree.setRootVisible(false)
        jtree.addKeyListener(ClipboardKeyListener.new)
        jtree
      end

      def internal_node_tree
        root_folders = Duse::Folder.all
        root = javax.swing.tree.DefaultMutableTreeNode.new("Root Folders");
        root_folders.each { |f| add_folder(root, f) }
        root
      end

      def add_folder(parent, folder)
        new_folder = new_node(folder)
        parent.add(new_folder)
        folder.subfolders.each { |sf| add_folder(new_folder, sf) }
        folder.secrets.each { |s| new_folder.add(new_secret_node(s)) }
      end

      def new_secret_node(o)
        javax.swing.tree.DefaultMutableTreeNode.new(o)
      end

      def new_node(o)
        javax.swing.tree.DefaultMutableTreeNode.new(o)
      end
    end
  end
end
