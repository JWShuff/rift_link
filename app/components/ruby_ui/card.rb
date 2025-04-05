# frozen_string_literal: true

module RubyUI
  class Card < Base
    def view_template(&)
      div(**attrs, &)
    end

    private

    def default_attrs
      {
        class: 'rounded-xl border border-white/10 bg-white/5 backdrop-blur-sm shadow-lg overflow-hidden',
      }
    end
  end
end
