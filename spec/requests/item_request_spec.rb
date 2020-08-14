require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "/update" do
    let(:sell_in) { 5 }
    let(:quality) { 10 }

    before do
      headers = { "ACCEPT" => "application/json" }
      post "/items", :params => { sell_in: sell_in, quality: quality, name: name }
    end

    context "normal item" do
      let(:name) { 'NORMAL ITEM' }

      context "before sell date" do
        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality - 1,
            "sell_in" => sell_in - 1,
          })
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality - 2,
          })
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality - 2,
          })
        end
      end

      context "of zero quality" do
        let(:quality) { 0 }

        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => 0 ,
          })
        end
      end
    end

    context "Aged Brie" do
      let(:name) { "Aged Brie" }

      context "before sell date" do
        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality + 1,
            "sell_in" => sell_in - 1,
          })
        end

        context "with max quality" do
          let(:quality) { 50 }

          it "adjusts quality" do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality,
            })
          end
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality + 2,
          })
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality + 2,
          })
        end

        context "with max quality" do
          let(:quality) { 50 }

          it "adjusts quality" do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality,
            })
          end
        end
      end
    end

    context "Sulfuras" do
      let(:quality) { 80 }
      let(:name) { 'Sulfuras, Hand of Ragnaros' }

      context "before sell date" do
        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality,
            "sell_in" => sell_in,
          })
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality,
          })
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality,
          })
        end
      end
    end

    context "Backstage pass" do
      let(:name) { 'Backstage passes to a TAFKAL80ETC concert' }

      context "long before sell date" do
        let(:sell_in) { 11 }

        it 'increases quality' do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality + 1,
          })
        end

        context "at max quality" do
          let(:quality) { 50 }

          it 'doesnt change quality' do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality,
            })
          end
        end
      end

      context "medium close to sell date (upper bound)" do
        let(:sell_in) { 10 }

        it 'increases quality' do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality + 2,
            })
        end

        context "at max quality" do
          let(:quality) { 50 }

          it 'doesnt change quality' do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality,
            })
          end
        end
      end

      context "medium close to sell date (lower bound)" do
        let(:sell_in) { 10 }

        it 'increases quality' do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality + 2,
            })
        end

        context "at max quality" do
          let(:quality) { 50 }

          it 'doesnt change quality' do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality,
            })
          end
        end
      end

      context "very close to sell date (upper bound)" do
        let(:sell_in) { 5 }

        it 'increases quality' do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality + 3,
            })
        end

        context "at max quality" do
          let(:quality) { 50 }

          it 'doesnt change quality' do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality,
            })
          end
        end
      end

      context "very close to sell date (lower bound)" do
        let(:sell_in) { 1 }

        it 'increases quality' do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality + 3,
            })
        end

        context "at max quality" do
          let(:quality) { 50 }

          it 'doesnt change quality' do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality,
            })
          end
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => 0,
          })
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => 0,
          })
        end
      end
    end

    xcontext "conjured item" do
      # Feature Request: Implement Conjured Mana Cake"

      let(:name) { 'Conjured Mana Cake' }

      it 'reduces sell in' do
        expect(JSON.parse(response.body)).to include({
          "sell_in" => sell_in - 1,
        })
      end

      context "before sell date" do
        let(:sell_in) { 5 }

        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality - 2,
          })
        end

        context "at zero quality" do
          let(:quality) { 0}

          it "does not adjusts quality" do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality,
            })
          end
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality - 4,
          })
        end

        context "at zero quality" do
          let(:quality) { 0}

          it "does not adjusts quality" do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality,
            })
          end
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "adjusts quality" do
          expect(JSON.parse(response.body)).to include({
            "quality" => quality - 4,
          })
        end

        context "at zero quality" do
          let(:quality) { 0 }

          it "does not adjusts quality" do
            expect(JSON.parse(response.body)).to include({
              "quality" => quality,
            })
          end
        end
      end
    end
  end
end
