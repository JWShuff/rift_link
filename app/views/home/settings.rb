# frozen_string_literal: true

module Views
  module Home
    class Settings < Views::Base
      prop :user, User, reader: :private
      prop :user_profile, UserProfile, reader: :private
      prop :active_tab, String, default: -> { 'profile' }, reader: :private

      def view_template
        div(class: 'container mx-auto py-8 px-4 max-w-5xl') do
          div(class: 'mb-8 text-center') do
            h1(class: 'text-3xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-cyan-300 to-purple-400') do
              'Account Settings'
            end
            p(class: 'text-white/60 mt-4') { 'Manage your profile, account, and preferences' }
          end

          # Main settings container
          div(class: 'bg-zinc-800/40 backdrop-blur-sm rounded-xl border border-white/10 overflow-hidden shadow-xl') do
            # RubyUI Tabs implementation
            render_rubyui_tabs
          end
        end
      end

      private

      def render_rubyui_tabs
        RubyUI::Tabs(default_value: active_tab) do
          # Tab List (Navigation)
          RubyUI::TabsList(class: 'w-full p-0 bg-zinc-800/60 border-b border-white/10') do
            tabs.each do |tab|
              RubyUI::TabsTrigger(
                value: tab[:id],
                class: 'data-[state=active]:border-b-2 data-[state=active]:border-cyan-400 data-[state=active]:bg-transparent data-[state=active]:text-cyan-300 data-[state=inactive]:text-white/70 rounded-none py-2.5 px-4',
              ) do
                render tab[:icon].new(class: 'h-4 w-4 mr-2 inline')
                span { tab[:name] }
              end
            end
          end

          # Tab Content
          tabs.each do |tab|
            RubyUI::TabsContent(value: tab[:id], class: 'p-6') do
              case tab[:id]
              when 'profile'
                Components::ProfileSettings(user_profile:)
              when 'account'
                Components::AccountSettings(user:)
              when 'sessions'
                Components::SessionSettings(user:)
              when 'danger'
                Components::DangerZoneSettings(user:)
              end
            end
          end
        end
      end

      def tabs
        [
          { id: 'profile', name: 'Profile', icon: Lucide::User },
          { id: 'account', name: 'Account', icon: Lucide::Shield },
          { id: 'sessions', name: 'Sessions', icon: Lucide::GlobeLock },
          { id: 'danger', name: 'Danger Zone', icon: Lucide::TriangleAlert },
        ]
      end
    end
  end
end
