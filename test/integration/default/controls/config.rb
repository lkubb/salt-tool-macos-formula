# frozen_string_literal: true

control 'tool_macos.config.file' do
  title 'Verify the configuration file'

  describe file('/home/user/.config/macos/config') do
    it { should be_file }
    it { should be_owned_by 'user' }
    it { should be_grouped_into 'user' }
    its('mode') { should cmp '0644' }
    its('content') do
      should include(
        'verify content here @FIXME'
      )
    end
  end
end
