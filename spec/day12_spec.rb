require_relative "../lib/day12.rb"

describe System do
  let(:example1_connections) do
    %w[
      start-A
      start-b
      A-c
      A-b
      b-d
      A-end
      b-end
    ]
  end

  let(:puzzle_connections) do
    %w[
        re-js
        qx-CG
        start-js
        start-bj
        qx-ak
        js-bj
        ak-re
        CG-ak
        js-CG
        bj-re
        ak-lg
        lg-CG
        qx-re
        WP-ak
        WP-end
        re-lg
        end-ak
        WP-re
        bj-CG
        qx-start
        bj-WP
        JG-lg
        end-lg
        lg-iw
      ]
  end

  context "with no small revisits allowed" do
    it "counts 1 path for the simplest system" do
      expect(System.new(['start-end']).path_count).to eq(1)
    end

    it "counts 2 paths for the simplest 2-path system" do
      connections = %w[
        start-a
        start-b
        a-end
        b-end
      ]
      expect(System.new(connections).path_count).to eq(2)
    end

    it "doesn't revisit a small cave (one with a lowercase name)" do
      connections = %w[
        start-a
        a-b
        a-end
      ]
      expect(System.new(connections).path_count).to eq(1)
    end

    it "replicates example 1" do
      expect(System.new(example1_connections).path_count).to eq(10)
    end

    it "replicates example 2" do
      connections = %w[
        dc-end
        HN-start
        start-kj
        dc-start
        dc-HN
        LN-dc
        HN-end
        kj-sa
        kj-HN
        kj-dc
      ]
      expect(System.new(connections).path_count).to eq(19)
    end

    it "replicates example 3" do
      connections = %w[
        fs-end
        he-DX
        fs-he
        start-DX
        pj-DX
        end-zg
        zg-sl
        zg-pj
        pj-he
        RW-he
        fs-DX
        pj-RW
        zg-RW
        start-pj
        he-WI
        zg-he
        pj-fs
        start-RW
      ]
      expect(System.new(connections).path_count).to eq(226)
    end

    it "solves the puzzle" do
      expect(System.new(puzzle_connections).path_count).to eq(3230)
    end

  end

  context "with 1 small revisit allowed" do
    it "allows 1 small revisit" do
      connections = %w[
        start-a
        a-b
        a-end
      ]
      expect(System.new(connections).path_count 1).to eq(2)
    end

    it "replicates example 1" do
      expect(System.new(example1_connections).path_count 1).to eq(36)
    end

    xit "solves the puzzle" do
      connections = %w[
        re-js
        qx-CG
        start-js
        start-bj
        qx-ak
        js-bj
        ak-re
        CG-ak
        js-CG
        bj-re
        ak-lg
        lg-CG
        qx-re
        WP-ak
        WP-end
        re-lg
        end-ak
        WP-re
        bj-CG
        qx-start
        bj-WP
        JG-lg
        end-lg
        lg-iw
      ]
      expect(System.new(connections).path_count 1).to eq(83475)
    end

  end

end
