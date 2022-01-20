require_relative "../lib/day16.rb"

describe Parser do
  let(:puzzle_packet) { '6053231004C12DC26D00526BEE728D2C013AC7795ACA756F93B524D8000AAC8FF80B3A7A4016F6802D35C7C94C8AC97AD81D30024C00D1003C80AD050029C00E20240580853401E98C00D50038400D401518C00C7003880376300290023000060D800D09B9D03E7F546930052C016000422234208CC000854778CF0EA7C9C802ACE005FE4EBE1B99EA4C8A2A804D26730E25AA8B23CBDE7C855808057C9C87718DFEED9A008880391520BC280004260C44C8E460086802600087C548430A4401B8C91AE3749CF9CEFF0A8C0041498F180532A9728813A012261367931FF43E9040191F002A539D7A9CEBFCF7B3DE36CA56BC506005EE6393A0ACAA990030B3E29348734BC200D980390960BC723007614C618DC600D4268AD168C0268ED2CB72E09341040181D802B285937A739ACCEFFE9F4B6D30802DC94803D80292B5389DFEB2A440081CE0FCE951005AD800D04BF26B32FC9AFCF8D280592D65B9CE67DCEF20C530E13B7F67F8FB140D200E6673BA45C0086262FBB084F5BF381918017221E402474EF86280333100622FC37844200DC6A8950650005C8273133A300465A7AEC08B00103925392575007E63310592EA747830052801C99C9CB215397F3ACF97CFE41C802DBD004244C67B189E3BC4584E2013C1F91B0BCD60AA1690060360094F6A70B7FC7D34A52CBAE011CB6A17509F8DF61F3B4ED46A683E6BD258100667EA4B1A6211006AD367D600ACBD61FD10CBD61FD129003D9600B4608C931D54700AA6E2932D3CBB45399A49E66E641274AE4040039B8BD2C933137F95A4A76CFBAE122704026E700662200D4358530D4401F8AD0722DCEC3124E92B639CC5AF413300700010D8F30FE1B80021506A33C3F1007A314348DC0002EC4D9CF36280213938F648925BDE134803CB9BD6BF3BFD83C0149E859EA6614A8C' }

  describe '#version_sum' do
    it "sums a single packet" do
      expect(subject.version_sum 'D2FE28').to eq(6)
    end

    it "handles an operator packet with length type ID 0" do
      expect(subject.version_sum '38006F45291200').to eq(9)
    end

    it "handles an operator packet with length type ID 1" do
      expect(subject.version_sum 'EE00D40C823060').to eq(14)
    end

    it "replicates example 3" do
      expect(subject.version_sum '8A004A801A8002F478').to eq(16)
    end

    it "replicates example 4" do
      expect(subject.version_sum '620080001611562C8802118E34').to eq(12)
    end

    it "replicates example 5" do
      expect(subject.version_sum 'C0015000016115A2E0802F182340').to eq(23)
    end

    it "replicates example 6" do
      expect(subject.version_sum 'A0016C880162017C3686B18A3D4780').to eq(31)
    end

    it "solves the puzzle" do
      expect(subject.version_sum puzzle_packet).to eq(953)
    end

  end

  describe '#result' do
    it "evaluates a single literal" do
      expect(subject.result 'D2FE28').to eq(2021)
    end

    it "sums subpackets" do
      expect(subject.result 'C200B40A82').to eq(3)
    end

    it "multiplies subpackets" do
      expect(subject.result '04005AC33890').to eq(54)
    end

    it "finds the minimum subpacket" do
      expect(subject.result '880086C3E88112').to eq(7)
    end

    it "finds the maximum subpacket" do
      expect(subject.result 'CE00C43D881120').to eq(9)
    end

    it "returns 1 if the first subpacket > the second, otherwise 0" do
      expect(subject.result 'F600BC2D8F').to eq(0)
    end

    it "returns 1 if the first subpacket < the second, otherwise 0" do
      expect(subject.result 'D8005AC2A8F0').to eq(1)
    end

    it "returns 1 if the first subpacket = the second, otherwise 0" do
      expect(subject.result '9C005AC2F8F0').to eq(0)
    end

    it "evaluates 1 + 3 == 2 * 2" do
      expect(subject.result '9C0141080250320F1802104A08').to eq(1)
    end

    it "solves the puzzle" do
      expect(subject.result puzzle_packet).to eq(246225449979)
    end

  end

end
