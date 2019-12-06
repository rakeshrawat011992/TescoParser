require "tescoParser/version"
require StoreDataTesco

module TescoParser
  class Error < StandardError;
  end

    @@products = nil
    @@breaktheLoop = false

    def isPreviousLineTotal(data, rowindex)
      rowindex > 0 && data[rowindex - 1]['text'].downcase == 'Total'.downcase
    end

    def isPreviousTextReducedPrice(data, rowindex)
      rowindex > 0 && isReducedPrice(data[rowindex - 1]['text'])
    end

    def isReducedPrice(text)
      text.match(/REDUCED PRICE/) || text.match(/PRICE/) || text.match(/REDUCED/)
    end

    def isCardOrCashSale(text)
      text.include?('VISA TRAVEL SALE') || text.include?('CASH') || text.include?('CHANGE DUE')  || text.include?('SALE')
    end

    def isLineAPrice(text)
      text.match(/EUR+([0-9]*[,])?([0-9]*[.])?+[0-9]+/) || text.match(/EUR+([O]*[,])?([O]*[.])?+[0-9]+/) ||
          text.match(/EUR+([0-9]*+\s+[.])?([0-9]*[.])?+[0-9]+/)
    end

    def isLineAUnitPrice(data, rowindex)
      isLineAPrice(data[rowindex + 1]['text']) && isLineAPrice(data[rowindex]['text'])
    end

    def isAKeyWord(text)
      isAKeyWord = false
      if text.size == 1 && text.match(/[a-cA-C]/)
        isAKeyWord = true
      elsif text.match(/[0-9]+%\sVAT/)
        isAKeyWord = true
      elsif text.match(/EURO+/)
        isAKeyWord = true
      elsif text.downcase == 'Total'.downcase || isReducedPrice(text) || isCardOrCashSale(text)
        isAKeyWord = true
        @@breaktheLoop = true
      elsif text.include?('CARD') || text.include?('Debit') || text.include?('Payment')
        isAKeyWord = true
      elsif text.downcase.include?('Total'.downcase) &&
          text.downcase.include?('Discount'.downcase)
        isAKeyWord = true
      end
      isAKeyWord
    end

    def getRelatedData(text, data, rowindex)

      if !isReducedPrice(text)
        if !@@products.empty? && isPreviousTextReducedPrice(data, rowindex)
          @@products.last.totalprice = text.to_f
          @@products.last.unitprice = text.to_f

        elsif !@@products.empty? && text.match(/[0-9]+\s+.+[@]/)

        elsif !@@products.empty? && isLineAUnitPrice(data, rowindex)
          @@products.last.unitprice = text[text.index('EUR') + 3, text.size].to_f

        else
          unless isAKeyWord(text)
            if isLineAPrice(text)
              @@products.last.totalprice = text[text.index('EUR') + 3, text.size].to_f
              if @@products.last.unitprice == 0.0
                @@products.last.productquantity = 1.0
                @@products.last.unitprice = @@products.last.totalprice
              else
                @@products.last.productquantity = @@products.last.totalprice / @@products.last.unitprice
              end
            elsif text.match(/EUR([0-9]*[.])?[0-9]+/) && isPreviousLineTotal(data, rowindex)
              @@breaktheLoop = true
            else
              item = StoreDataTesco.new
              item.productquantity = 1
              item.productname = text.strip
              item.discount = 0.0
              item.unitprice = 0.0
              item.totalprice = 0.0
              @@products.push(item)
            end
          end
        end
      end
    end

    def parseTheData(textresult)



      @@products = []
      rowindex = 0
      startprocess = false
      @@breaktheLoop = false
      textresult.each do |line|
        if !line['text'].empty? && !@@breaktheLoop && line['confidence'].to_i > 50
          if !startprocess && (line['text'].include?('EUR') || line['text'] == 'REDUCED PRICE')
            startprocess = true
            if rowindex > 0
              rowindex = rowindex - 1
            end
            next
          end

          if startprocess
            text = textresult[rowindex]['text']
            next if text.include?('----')
            getRelatedData(text, textresult, rowindex)
          end
        end
        rowindex += 1
      end
      @@products
    end
end
