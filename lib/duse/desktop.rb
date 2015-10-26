require "java"
require "duse/desktop/clipboard"

module Duse
  module Desktop
    class ClipboardKeyListener
      def keyPressed(e)
        if e.isControlDown && e.getKeyChar != "c" && e.getKeyCode == 67
          selection = e.getSource.getSelectedValuesList
          if selection.size == 1
            secret = selection.first
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

    DefaultListCellRenderer = javax.swing.DefaultListCellRenderer
    class SecretListCellRenderer < DefaultListCellRenderer
      def getListCellRendererComponent(list, value, index, isSelected, cellHasFocus)
        renderer = super(list, value, index, isSelected, cellHasFocus)
        renderer.setText(value.title)
        renderer
      end
    end

    class App
      def run
        frame  = javax.swing.JFrame.new
        secrets = Duse::Secret.all
        jlist = javax.swing.JList.new(secrets.to_java)
        jlist.addKeyListener(ClipboardKeyListener.new)
        jlist.setCellRenderer(SecretListCellRenderer.new)
        frame.add(jlist)
        frame.setDefaultCloseOperation(javax.swing.JFrame::EXIT_ON_CLOSE)
        frame.pack
        frame.setVisible(true)
      end
    end
  end
end
