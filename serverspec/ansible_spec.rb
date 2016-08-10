
describe 'Test Hostname' do
  it 'hostname is test_ansible' do
    expect(command('printf "$(hostname)"').stdout).to eq('ansible')
  end
end
