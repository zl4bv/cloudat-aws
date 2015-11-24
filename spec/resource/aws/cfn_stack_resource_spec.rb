require 'cloudat'
require 'cloudat/resource/aws/cfn_stack_resource'

describe Cloudat::Resource::Aws::CfnStackResource do
  let(:stack) { double('Aws::CloudFormation::Stack') }

  describe '#find_cfn_stacks' do
    context 'when called with a stack name' do
      subject do
        Cloudat::Resource::Aws::CfnStackResource.find_cfn_stacks(nil,
                                                                 stack_name: 'test_stack')
      end

      it 'is expected to use the optimized method of the aws sdk' do
        expect(Cloudat::Resource::Aws::CfnStackResource).to receive(:find_stack)
        subject
      end
    end

    context 'when called with a Regexp' do
      let(:helper) do
        double(Cloudat::Aws::CfnStackHelper, unique_stack_id?: false,
                                             selected?: true)
      end

      subject do
        Cloudat::Resource::Aws::CfnStackResource.find_cfn_stacks(nil,
                                                                 stack_name: /test_stack/,
                                                                 helper: helper)
      end

      it 'is expected to return a list of Stacks' do
        expect(Cloudat::Resource::Aws::CfnStackResource).to(
          receive_message_chain(:resource, :stacks)
          .and_return [stack])
        expect(subject).to include stack
      end
    end
  end
end
