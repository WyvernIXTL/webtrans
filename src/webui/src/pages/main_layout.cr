abstract class MainLayout
  include Lucky::HTMLPage

  # 'needs current_user : User' makes it so that the current_user
  # is always required for pages using MainLayout
  needs current_user : User

  abstract def content
  abstract def page_title

  # MainLayout defines a default 'page_title'.
  #
  # Add a 'page_title' method to your indivual pages to customize each page's
  # title.
  #
  # Or, if you want to require every page to set a title, change the
  # 'page_title' method in this layout to:
  #
  #    abstract def page_title : String
  #
  # This will force pages to define their own 'page_title' method.
  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html class: "h-100", lang: "en" do
      mount Shared::LayoutHead, page_title: page_title

      body class: "d-flex flex-column h-100" do
        mount Shared::Header, user_email: current_user.email

        mount Shared::FlashMessages, context.flash
        
        content
        
        mount Shared::Footer
      end
    end
  end
end
