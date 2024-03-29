
# Parent class for all pages that do not distinguish between user or guest.
abstract class AuthLayout
  include Lucky::HTMLPage

  abstract def content
  abstract def page_title

  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html class: "h-100", lang: "en" do
      mount Shared::LayoutHead, page_title: page_title
    
      body class: "d-flex flex-column h-100" do
        mount Shared::FlashMessages, context.flash
        main class: "flex-shrink-0" do
          content
        end
    
        mount Shared::Footer
      end
    end
  end
end
