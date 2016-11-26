require 'spec_helper'

module Metrica
  module Adapters
    class InfluxDbTestAdapter < BaseAdapter
    end

    class InfluxDbNilAdapter
      def self.instance(_)
      end
    end
  end
end

describe Metrica do
  describe '#service' do
    subject { Metrica.service }

    it { expect(subject.instance_eval { @adapter }).to be_an_instance_of(Metrica::Adapters::FakeAdapter) }

    context 'when custom adapter was specified' do
      let(:adapter) { Metrica::Adapters::InfluxDbTestAdapter }
      before { Metrica.configure { |c| c.adapter = adapter }}

      it { expect(subject.instance_eval { @adapter }).to be_an_instance_of(adapter) }
    end

    context 'when custom adapter with wrong initialization was specified' do
      before { Metrica.configure { |c| c.adapter = Metrica::Adapters::InfluxDbNilAdapter }}

      it { expect(subject.instance_eval { @adapter }).to be_an_instance_of(Metrica::Adapters::FakeAdapter) }
    end
  end

  describe '#write_point(name, data)' do
    it 'should call write_point of appropriate adapter' do
      allow(Metrica.service).to receive(:write_point).with('test', 'value').once
      Metrica.write_point('test', 'value')
    end
  end

  describe '#query(query)' do
    it 'should call query of appropriate adapter' do
      allow(Metrica.service).to receive(:query).with('SELECT * FROM metrics').once
      Metrica.query('SELECT * FROM metrics')
    end
  end
end
