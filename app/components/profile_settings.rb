# frozen_string_literal: true

module Components
  class ProfileSettings < Components::Base
    prop :user_profile, UserProfile, reader: :private

    def view_template
      turbo_frame_tag 'settings-profile-content' do
        div(class: 'flex flex-row gap-2 align-center') do
          RubyUI::Heading(level: 2, class: 'mb-6 flex items-center') do
            Lucide::User class: 'h-5 w-5 mr-2 text-cyan-400'
            'Profile Settings'
          end

          RubyUI::Text(as: 'p', class: 'mb-6 text-white/60') do
            'Manage how others see you in RiftLink'
          end
        end

        render_form
      end
    end

    private

    def render_form
      form_with(model: user_profile, url: update_profile_path, method: :patch, class: 'space-y-6') do |form|
        render_avatar_section(form)

        # Username field with RubyUI
        RubyUI::Card(class: 'mb-6') do
          RubyUI::CardHeader() do
            RubyUI::CardTitle() { 'Profile info' }
          end
          RubyUI::CardContent() do
            div(class: 'grid gap-4 mt-4') do
              # Username field
              div do
                RubyUI::Text(as: 'label', for: 'user_profile_username', weight: 'medium', size: 'sm') do
                  'Username'
                end
                form.text_field :username,
                  class: 'mt-1 w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/40 focus:outline-none focus:ring-1 focus:ring-cyan-400/50 focus:border-cyan-400/50'

                if user_profile.errors[:username].any?
                  div(class: 'mt-1 text-red-400 text-sm') { user_profile.errors[:username].join(', ') }
                end
              end

              # Display name field
              div do
                RubyUI::Text(as: 'label', for: 'user_profile_display_name', weight: 'medium', size: 'sm') do
                  'Display Name'
                end
                form.text_field :display_name,
                  class: 'mt-1 w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/40 focus:outline-none focus:ring-1 focus:ring-cyan-400/50 focus:border-cyan-400/50'
              end

              # Bio field
              div do
                RubyUI::Text(as: 'label', for: 'user_profile_bio', weight: 'medium', size: 'sm') do
                  'Bio'
                end
                form.text_area :bio, rows: 3,
                  class: 'mt-1 w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white placeholder-white/40 focus:outline-none focus:ring-1 focus:ring-cyan-400/50 focus:border-cyan-400/50',
                  placeholder: 'Tell us about yourself...'
              end

              # Gaming status
              div do
                RubyUI::Text(as: 'label', for: 'user_profile_gaming_status', weight: 'medium', size: 'sm') do
                  'Gaming Status'
                end
                div(class: 'mt-1') do
                  form.select :gaming_status,
                    [
                      ['Online', 'online'],
                      ['Away', 'away'],
                      ['Busy', 'busy'],
                      ['Offline', 'offline'],
                    ],
                    selected: user_profile.gaming_status,
                    class: 'w-full px-3 py-2 bg-white/5 border border-white/10 rounded-md text-white focus:outline-none focus:ring-1 focus:ring-cyan-400/50 focus:border-cyan-400/50'
                end
              end
            end
          end
        end

        div(class: 'flex justify-end') do
          RubyUI::Button(variant: :primary, type: :submit) do
            'Save Profile'
          end
        end
      end
    end

    def render_avatar_section(form)
      RubyUI::Card(class: 'mb-6') do
        RubyUI::CardHeader() do
          RubyUI::CardTitle() { 'Avatar' }
          RubyUI::CardDescription() { 'Your profile image across RiftLink' }
        end
        RubyUI::CardContent() do
          div(class: 'flex items-center gap-4 mt-4', data: { controller: 'avatar-preview' }) do
            div(class: 'relative h-20 w-20 rounded-full bg-gradient-to-br from-cyan-500 to-purple-600 flex items-center justify-center overflow-hidden border-2 border-white/10', data: { 'avatar-preview-target': 'container' }) do
              if user_profile.user.avatar.attached?
                image_tag url_for(user_profile.user.avatar),
                  alt: "#{user_profile.username}'s avatar",
                  class: 'w-full h-full object-cover',
                  data: { 'avatar-preview-target': 'preview' }
              else
                span(class: 'text-white text-xl font-bold') { user_profile.username ? user_profile.username[0..1].upcase : '??' }
              end
            end

            div(class: 'flex-1') do
              div(class: 'relative') do
                form.file_field :avatar,
                  class: 'absolute inset-0 w-full h-full opacity-0 cursor-pointer z-10',
                  accept: 'image/jpeg,image/png,image/gif',
                  direct_upload: true,
                  data: {
                    action: 'change->avatar-preview#updatePreview',
                    direct_upload_url: rails_direct_uploads_path,
                  }

                div(class: 'flex flex-col') do
                  div(class: 'flex items-center') do
                    RubyUI::Button(variant: :secondary, size: :sm, type: :button) do
                      Lucide::Upload class: 'h-4 w-4 mr-2'
                      span { 'Choose File' }
                    end

                    span(class: 'ml-2 text-sm text-white/70', data: { 'avatar-preview-target': 'filename' }) do
                      user_profile.user.avatar.attached? ? 'Current avatar selected' : 'No file selected'
                    end
                  end

                  RubyUI::Text(as: 'p', size: '1', class: 'mt-1 text-white/50') do
                    'JPG, GIF or PNG. Max size 2MB.'
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
