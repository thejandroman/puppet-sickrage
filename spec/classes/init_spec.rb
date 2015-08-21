require 'spec_helper'

describe 'sickrage' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "sickrage class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          # Init
          it { is_expected.to contain_class('sickrage') \
            .that_requires('sickrage::service') }
          it { is_expected.to contain_class('sickrage::params') }
          it { is_expected.to contain_class('sickrage::install') }
          it { is_expected.to contain_class('sickrage::service') \
            .that_requires('sickrage::install') }

          # Install
          it { is_expected.to contain_package('git') }
          it { is_expected.to contain_package('libssl-dev') }
          it { is_expected.to contain_package('pyopenssl') \
             .with_provider('pip') }
          it { is_expected.to contain_package('python-cheetah') }
          it { is_expected.to contain_package('python-dev') }
          it { is_expected.to contain_package('python-pip') }
          it { is_expected.to contain_package('unrar') }
          it { is_expected.to contain_wget__fetch('sickrage download') \
            .that_comes_before('Exec[sickrage extract]') }
          it { is_expected.to contain_file('/srv/sickrage') \
            .with_ensure('directory') \
            .with_owner('sickrage') \
            .that_comes_before('Exec[sickrage extract]') }
          it { is_expected.to contain_exec('sickrage extract') \
            .with_user('sickrage') }
          it { is_expected.to contain_user('sickrage') \
            .that_comes_before('File[/srv/sickrage]')\
            .that_comes_before('Exec[sickrage extract]') }

          it { is_expected.to contain_file('/etc/default/sickrage') \
            .that_notifies('Service[sickrage]') }
          it { is_expected.to contain_file('/etc/init/sickrage.conf') \
            .that_notifies('Service[sickrage]') }
          it { is_expected.to contain_service('sickrage') \
            .with_provider('upstart') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'sickrage class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('sickrage') } \
        .to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
