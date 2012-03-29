require 'spec_helper'

describe Wallet do
  context "calculates the balance" do
    it "sums the transaction amounts" do
      Payment.should_receive(:sum).with(:amount) { BigDecimal("10") }
      Wallet.balance.should == BigDecimal("10")
    end
  end
  
  context "sending bitcoins" do
    let(:address) { BitcoinAddress.create!( 
        private_key: "1e2e0bc6893d42a462b0039b5c15c3da3378c8d0ec44556b9608efdb2b3caff1",
        description: "test"
    ) }
    
    before :each do
      TransactionImporter.refresh_for [address]
      # Pretend the last transaction (spending bitcoins) hasn't happened, so appears
      # balance is 0.1
      address.transactions.first.destroy
      address.payments.first.destroy
    end
    
    it "reduces the balance" do
      Wallet.send_bitcoins(to: BitcoinAddress.generate.address, amount: 0.02)
      Wallet.balance.should == 0.08
    end
    
    it "transmits the transaction" do
      Api::TransactionTransmitter.should_receive(:transmit)
      Wallet.send_bitcoins(to: BitcoinAddress.generate.address, amount: 0.02)
    end
    
    it "errors out if there is not enough balance"
  end
  
end