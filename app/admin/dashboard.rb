ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Help Resources" do
          ul do
            li link_to "How To Use", "https://drive.google.com/open?id=18OxBkqPzaDKkIlOYtt329OuILu5qJTHb"
            li link_to "Create Custom Slide", "https://drive.google.com/open?id=1wJPoc9JG9ga3tdNUjDd1ZSB9mPwNWNZ4"
            li link_to "PCOE Overview and Setup", "https://github.com/CTC-PCOEdeSignage/PCOE-de-Signage-Rails/blob/master/README.md"
            li link_to "Other Documentation", "https://github.com/CTC-PCOEdeSignage/PCOE-de-Signage-Rails/tree/master/documentation"
            li link_to "Github Repo", "https://github.com/CTC-PCOEdeSignage/PCOE-de-Signage-Rails"
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to PCOE de Signage"
        end
      end
    end
  end # content
end
