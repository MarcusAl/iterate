module Sanitizable
  extend ActiveSupport::Concern

  class_methods do
    def sanitize_string(text)
      return nil if text.nil?

      ActionController::Base.helpers.sanitize(
        text.strip,
        tags: [],
        attributes: []
      ).squish
    end

    def sanitize_text(text)
      return nil if text.nil?

      ActionController::Base.helpers.sanitize(
        text.strip,
        tags: %w[b i u p br],
        attributes: []
      )
    end

    def sanitize_array(array)
      return [] if array.nil?

      array.compact
           .map { |item| sanitize_string(item) }
           .reject(&:blank?)
           .uniq
    end
  end
end
