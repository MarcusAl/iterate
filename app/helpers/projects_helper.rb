module ProjectsHelper
  def status_color_class(status)
    case status.to_sym
    when :draft
      'bg-gray-100 text-gray-800'
    when :in_progress
      'bg-blue-100 text-blue-800'
    when :completed
      'bg-green-100 text-green-800'
    when :cancelled
      'bg-red-100 text-red-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end
end
