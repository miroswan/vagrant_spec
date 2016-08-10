
describe 'Test Hostname' do
  it 'hostname is test_pansible' do
    expect(command('printf "$(hostname)"').stdout).to eq('pansible')
  end
end
