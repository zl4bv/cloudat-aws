require 'cloudat/aws/backoff'

class ThrottlingException < RuntimeError; end

def throttle(failure_count)
  @attempt += 1
  raise ThrottlingException if @attempt < failure_count
end

describe '#with_backoff' do
  before do
    @attempt = 0
  end

  subject do
    Cloudat::Aws.with_backoff(max_retries, ThrottlingException) do
      throttle(failure_count)
    end
  end

  context 'when Throttling occurs many times' do
    let(:failure_count) { 10 }
    let(:max_retries) { 2 }

    it 'is expected to fail' do
      expect { subject }.to raise_error ThrottlingException
    end
  end

  context 'when Throttling occurs twice' do
    context 'when max_retries is 1' do
      let(:failure_count) { 2 }
      let(:max_retries) { 1 }

      it 'is expected to fail' do
        expect { subject }.to raise_error ThrottlingException
      end
    end

    context 'when max_retries is 2' do
      let(:failure_count) { 2 }
      let(:max_retries) { 2 }

      it 'is expected to retry and succeed' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
