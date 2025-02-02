module ApplicationHelper
  include Pagy::Frontend

  def pagy_nav(pagy)
    pagy_nav_tailwind(pagy)
  end

  private

  def pagy_nav_tailwind(pagy)
    link = '<a href="%<href>s" data-turbo-stream="true" class="relative inline-flex items-center px-4 py-2 border text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 %<class>s">%<text>s</a>'

    current = '<span class="relative inline-flex items-center px-4 py-2 border text-sm font-medium rounded-md text-white bg-blue-600">%<text>s</span>'

    gap = '<span class="relative inline-flex items-center px-4 py-2 border text-sm font-medium rounded-md text-gray-700 bg-gray-100">...</span>'

    pagy_nav_html(pagy, link: link, current: current, gap: gap)
  end
end
