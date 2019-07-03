require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq 'foo'
    end

    it 'degrades quality by 1 for regular items' do
      items = [Item.new('Hammer of Thor', 10, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 9
      expect(items[0].sell_in).to eq 9
    end

    it 'does not degrades quality or sell_in for Sulfuras' do
      items = [
          Item.new('Sulfuras, Hand of Ragnaros', 5, 80),
          Item.new('Sulfuras, Hand of Ragnaros', -5, 80)
      ]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 80
      expect(items[0].sell_in).to eq 5
      expect(items[1].quality).to eq 80
      expect(items[1].sell_in).to eq -5
    end

    it 'increases quality for Aged Brie' do
      items = [Item.new('Aged Brie', 5, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 21
      expect(items[0].sell_in).to eq 4
    end

    it 'increases quality for Aged Brie by two fold after sell_in' do
      items = [Item.new('Aged Brie', -5, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 22
      expect(items[0].sell_in).to eq -6
    end

    it 'does not increases quality for Aged Brie beyond 50' do
      items = [Item.new('Aged Brie', 5, 50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 50
      expect(items[0].sell_in).to eq 4
    end

    it 'degrades quality of conjured items by 2 before sell_in' do
      items = [Item.new('Conjured Mana Cake', 10, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 8
      expect(items[0].sell_in).to eq 9
    end

    it 'degrades quality of conjured items by 4 after sell_in' do
      items = [Item.new('Conjured Mana Cake', -1, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 6
      expect(items[0].sell_in).to eq -2
    end

    it 'degrades quality but never less then 0' do
      items = [Item.new('Conjured Mana Cake', -5, 3)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
      expect(items[0].sell_in).to eq -6

      items = [Item.new('Hammer of Thor', 0, 1)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
      expect(items[0].sell_in).to eq -1
    end
  end
end
