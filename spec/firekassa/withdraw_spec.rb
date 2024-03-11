# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Firekassa::Withdraw do
  before do
    Firekassa.configure do |config|
      config.base_url = "https://admin.vanilapay.com"
      config.api_token = "testtokenvalue"
    end
  end

  let(:withdraw) { described_class.new }

  describe "#create_card" do
    subject(:result) { withdraw.create_card(withdraw_data) }

    let(:valid_withdraw_data) do
      {
        order_id: "11_03_2024_17_49",
        site_account: "sber",
        account: "2200700168000817",
        amount: "101.00"
      }
    end

    let(:withdraw_response) do
      {
        "amount" => "101.00",
        "commission" => "3.54",
        "id" => "516551132"
      }
    end

    context "when transaction is valid", vcr: "withdraw/create_card" do
      let(:withdraw_data) { valid_withdraw_data }

      it "returns Withdraw response" do
        expect(result).to eq(withdraw_response)
      end
    end

    context "when amount is too small", vcr: "withdraw/amount_is_too_small_error" do
      let(:withdraw_data) do
        valid_withdraw_data.merge({ amount: "1.00" })
      end

      let(:error_data) do
        {
          "message" => "The given data was invalid",
          "errors" => {
            "amount" => ["Min amount is 100.00."]
          }
        }
      end

      it "returns validation error response", aggregate_failures: true do
        expect { result }.to raise_error do |error|
          expect(error.data).to eql(error_data)
        end
      end
    end
  end

  describe "#create_sbp" do
    subject(:result) { withdraw.create_sbp(withdraw_data) }

    let(:valid_withdraw_data) do
      {
        order_id: "11_03_2024_19_13",
        site_account: "sber",
        account: "89221186680",
        amount: "101.00",
        bank_id: "100000000004"
      }
    end

    let(:withdraw_response) do
      {
        "amount" => "101.00",
        "commission" => "2.02",
        "id" => "516551479"
      }
    end

    context "when transaction is valid", vcr: "withdraw/create_sbp" do
      let(:withdraw_data) { valid_withdraw_data }

      it "returns Withdraw response" do
        expect(result).to eq(withdraw_response)
      end
    end
  end

  describe "#sbp_banks" do
    subject(:result) { withdraw.sbp_banks }

    context "when request_data is valid", vcr: "withdraw/sbp_banks" do
      let(:response) do
        [
          { "code" => "100000000004", "name" => "Тинькофф Банк" },
          { "code" => "100000000015", "name" => "Банк ОТКРЫТИЕ" },
          { "code" => "100000000008", "name" => "АЛЬФА-БАНК" },
          { "code" => "100000000030", "name" => "ЮниКредит Банк" },
          { "code" => "110000000005", "name" => "Банк ВТБ" },
          { "code" => "100000000013", "name" => "Совкомбанк" },
          { "code" => "100000000003", "name" => "Банк Синара" },
          { "code" => "100000000029", "name" => "Банк Санкт-Петербург" },
          { "code" => "100000000022", "name" => "НКО ЮМани" },
          { "code" => "100000000172", "name" => "Банк Развитие-Столица" },
          { "code" => "100000000135", "name" => "Банк Акцепт" },
          { "code" => "100000000099", "name" => "КБ Модульбанк" },
          { "code" => "100000000140", "name" => "МБ Банк" },
          { "code" => "100000000069", "name" => "СДМ-Банк" },
          { "code" => "100000000159", "name" => "АКБ Энергобанк" },
          { "code" => "100000000118", "name" => "КБ АГРОПРОМКРЕДИТ" },
          { "code" => "100000000122", "name" => "ИК Банк" },
          { "code" => "100000000229", "name" => "МС Банк Рус" },
          { "code" => "100000000092", "name" => "БыстроБанк" },
          { "code" => "100000000098", "name" => "КБ РостФинанс" },
          { "code" => "100000000052", "name" => "Банк Левобережный" },
          { "code" => "100000000087", "name" => "Банк ПСКБ" },
          { "code" => "100000000082", "name" => "Банк ДОМ.РФ" },
          { "code" => "100000000121", "name" => "КБ Солидарность" },
          { "code" => "100000000056", "name" => "КБ Хлынов" },
          { "code" => "100000000095", "name" => "АБ РОССИЯ" },
          { "code" => "100000000049", "name" => "Банк ВБРР" },
          { "code" => "100000000012", "name" => "РОСБАНК" },
          { "code" => "100000000043", "name" => "Газэнергобанк" },
          { "code" => "100000000086", "name" => "ПНКО ЭЛПЛАТ" },
          { "code" => "100000000010", "name" => "Промсвязьбанк" },
          { "code" => "100000000153", "name" => "Банк Венец" },
          { "code" => "100000000202", "name" => "Норвик Банк" },
          { "code" => "100000000189", "name" => "ТАТСОЦБАНК" },
          { "code" => "100000000208", "name" => "Северный Народный Банк" },
          { "code" => "100000000113", "name" => "АКБ Алеф-Банк" },
          { "code" => "100000000151", "name" => "КБ Урал ФД" },
          { "code" => "100000000107", "name" => "АКИБАНК" },
          { "code" => "100000000211", "name" => "Банк АЛЕКСАНДРОВСКИЙ" },
          { "code" => "100000000081", "name" => "АКБ Форштадт" },
          { "code" => "100000000206", "name" => "Томскпромстройбанк" },
          { "code" => "100000000130", "name" => "Автоградбанк" },
          { "code" => "100000000058", "name" => "ВЛАДБИЗНЕСБАНК" },
          { "code" => "100000000106", "name" => "ЧЕЛИНДБАНК" },
          { "code" => "100000000183", "name" => "Газтрансбанк" },
          { "code" => "100000000158", "name" => "Банк ИТУРУП" },
          { "code" => "100000000193", "name" => "КБ СТРОЙЛЕСБАНК" },
          { "code" => "100000000093", "name" => "Углеметбанк" },
          { "code" => "100000000171", "name" => "МОРСКОЙ БАНК" },
          { "code" => "100000000142", "name" => "УРАЛПРОМБАНК" },
          { "code" => "100000000215", "name" => "ВУЗ-банк" },
          { "code" => "100000000037", "name" => "ГЕНБАНК" },
          { "code" => "100000000170", "name" => "Банк Интеза" },
          { "code" => "100000000014", "name" => "Банк Русский Стандарт" },
          { "code" => "100000000091", "name" => "БАНК СНГБ" },
          { "code" => "100000000235", "name" => "АКБ Держава" },
          { "code" => "100000000094", "name" => "ЧЕЛЯБИНВЕСТБАНК" },
          { "code" => "100000000152", "name" => "Тольяттихимбанк" },
          { "code" => "100000000173", "name" => "Таврический Банк" },
          { "code" => "100000000126", "name" => "Банк Саратов" },
          { "code" => "100000000177", "name" => "АКБ НОВИКОМБАНК" },
          { "code" => "100000000200", "name" => "АКБ СЛАВИЯ" },
          { "code" => "100000000192", "name" => "Банк МБА-МОСКВА" },
          { "code" => "100000000042", "name" => "КБ ЮНИСТРИМ" },
          { "code" => "100000000216", "name" => "Банк Финсервис" },
          { "code" => "100000000245", "name" => "АКБ Ланта-Банк" },
          { "code" => "100000000233", "name" => "НК Банк" },
          { "code" => "100000000138", "name" => "Тойота Банк" },
          { "code" => "100000000180", "name" => "Кубаньторгбанк" },
          { "code" => "100000000184", "name" => "АКБ НРБанк" },
          { "code" => "100000000272", "name" => "Хайс Банк" },
          { "code" => "100000000032", "name" => "КБ Ренессанс Кредит" },
          { "code" => "100000000212", "name" => "КБ Крокус-Банк" },
          { "code" => "100000000175", "name" => "АКБ ТЕНДЕР-БАНК" },
          { "code" => "100000000236", "name" => "Банк ИПБ" },
          { "code" => "100000000226", "name" => "АКБ Приморье" },
          { "code" => "100000000165", "name" => "Русьуниверсалбанк" },
          { "code" => "100000000026", "name" => "БАНК УРАЛСИБ" },
          { "code" => "100000000128", "name" => "КБ Ситибанк" },
          { "code" => "100000000144", "name" => "Тимер Банк" },
          { "code" => "100000000125", "name" => "ГОРБАНК" },
          { "code" => "100000000227", "name" => "Банк БКФ" },
          { "code" => "100000000217", "name" => "АКБ ФОРА-БАНК" },
          { "code" => "100000000199", "name" => "ИШБАНК" },
          { "code" => "100000000148", "name" => "КБ СИНКО-БАНК" },
          { "code" => "100000000112", "name" => "КБ Гарант-Инвест" },
          { "code" => "100000000059", "name" => "КБ Центр-инвест" },
          { "code" => "100000000197", "name" => "АКБ Трансстройбанк" },
          { "code" => "100000000136", "name" => "МЕТКОМБАНК" },
          { "code" => "100000000105", "name" => "Эс-Би-Ай Банк" },
          { "code" => "100000000194", "name" => "КБ РУСНАРБАНК" },
          { "code" => "100000000066", "name" => "Земский банк" },
          { "code" => "100000000111", "name" => "Сбербанк" },
          { "code" => "100000000046", "name" => "Металлинвестбанк" },
          { "code" => "100000000017", "name" => "МТС-Банк" },
          { "code" => "100000000286", "name" => "Банк Оранжевый" },
          { "code" => "100000000273", "name" => "Озон Банк (Ozon)" },
          { "code" => "100000000266", "name" => "банк Элита" },
          { "code" => "100000000296", "name" => "Плайт" },
          { "code" => "100000000282", "name" => "ЦМРБанк" },
          { "code" => "100000000137", "name" => "Первый Дортрансбанк" },
          { "code" => "100000000265", "name" => "Цифра банк" },
          { "code" => "100000000117", "name" => "ПроБанк" },
          { "code" => "100000000160", "name" => "ЮГ-Инвестбанк" },
          { "code" => "100000000284", "name" => "Банк Точка" },
          { "code" => "100000000040", "name" => "Банк ФИНАМ" },
          { "code" => "100000000163", "name" => "Снежинский" },
          { "code" => "100000000231", "name" => "ЦентроКредит" },
          { "code" => "100000000102", "name" => "Банк Агророс" },
          { "code" => "100000000096", "name" => "Уралфинанс" },
          { "code" => "100000000149", "name" => "ГУТА-БАНК" },
          { "code" => "100000000196", "name" => "Инбанк" },
          { "code" => "100000000228", "name" => "Прио-Внешторгбанк" },
          { "code" => "100000000247", "name" => "банк Раунд" },
          { "code" => "100000000278", "name" => "ФИНСТАР БАНК" },
          { "code" => "100000000250", "name" => "Драйв Клик Банк" },
          { "code" => "100000000234", "name" => "БАНК МОСКВА-СИТИ" },
          { "code" => "100000000161", "name" => "КБ ЛОКО-Банк" },
          { "code" => "100000000150", "name" => "Яндекс Банк" },
          { "code" => "100000000260", "name" => "Банк БЖФ" },
          { "code" => "100000000041", "name" => "БКС Банк" },
          { "code" => "100000000167", "name" => "АКБ ЕВРОФИНАНС МОСНАРБАНК" },
          { "code" => "100000000067", "name" => "КБ Новый век" },
          { "code" => "100000000028", "name" => "АКБ АВАНГАРД" },
          { "code" => "100000000270", "name" => "КБ Долинск" },
          { "code" => "100000000133", "name" => "ББР Банк" },
          { "code" => "100000000222", "name" => "УКБ Новобанк" },
          { "code" => "100000000110", "name" => "КБ Москоммерцбанк" },
          { "code" => "100000000219", "name" => "Севергазбанк" },
          { "code" => "100000000225", "name" => "УКБ Белгородсоцбанк" },
          { "code" => "100000000024", "name" => "Хоум кредит" },
          { "code" => "100000000018", "name" => "ОТП Банк" },
          { "code" => "100000000103", "name" => "КБ Пойдём!" },
          { "code" => "100000000031", "name" => "КБ УБРиР" },
          { "code" => "100000000078", "name" => "Ингосстрах Банк" },
          { "code" => "100000000181", "name" => "Автоторгбанк" },
          { "code" => "100000000176", "name" => "МОСКОМБАНК" },
          { "code" => "100000000169", "name" => "МП Банк" },
          { "code" => "100000000045", "name" => "Банк ЗЕНИТ" },
          { "code" => "100000000223", "name" => "СОЦИУМ-БАНК" },
          { "code" => "100000000070", "name" => "Датабанк" },
          { "code" => "100000000205", "name" => "Банк Заречье" },
          { "code" => "100000000191", "name" => "КБЭР Банк Казани" },
          { "code" => "100000000232", "name" => "РЕАЛИСТ БАНК" },
          { "code" => "100000000154", "name" => "Банк Аверс" },
          { "code" => "100000000071", "name" => "НС Банк" },
          { "code" => "100000000213", "name" => "Джей энд Ти Банк" },
          { "code" => "100000000182", "name" => "Банк Объединенный капитал" },
          { "code" => "100000000129", "name" => "КБ АРЕСБАНК" },
          { "code" => "100000000248", "name" => "КБ ВНЕШФИНБАНК" },
          { "code" => "100000000185", "name" => "Нацинвестпромбанк" },
          { "code" => "100000000230", "name" => "АКБ Солид" },
          { "code" => "100000000203", "name" => "АКБ МЕЖДУНАРОДНЫЙ ФИНАНСОВЫЙ КЛУБ" },
          { "code" => "100000000195", "name" => "Кузнецкбизнесбанк" },
          { "code" => "100000000062", "name" => "НОКССБАНК" },
          { "code" => "100000000115", "name" => "НИКО-БАНК" },
          { "code" => "100000000174", "name" => "Первый Инвестиционный Банк" },
          { "code" => "100000000253", "name" => "Авто Финанс Банк" },
          { "code" => "100000000064", "name" => "Кредит Урал Банк" },
          { "code" => "100000000090", "name" => "Банк Екатеринбург" },
          { "code" => "100000000243", "name" => "Банк Национальный стандарт" },
          { "code" => "100000000083", "name" => "Дальневосточный банк" },
          { "code" => "100000000016", "name" => "Почта Банк" },
          { "code" => "100000000258", "name" => "АИКБ Енисейский объединенный банк" },
          { "code" => "100000000134", "name" => "НБД-Банк" },
          { "code" => "100000000034", "name" => "ТКБ БАНК" },
          { "code" => "100000000201", "name" => "Банк Кремлевский" },
          { "code" => "100000000088", "name" => "СКБ Приморья Примсоцбанк" },
          { "code" => "100000000084", "name" => "РосДорБанк" },
          { "code" => "100000000065", "name" => "Точка ФК Открытие" },
          { "code" => "100000000050", "name" => "КБ Кубань Кредит" },
          { "code" => "100000000187", "name" => "Банк РЕСО Кредит" },
          { "code" => "100000000166", "name" => "СИБСОЦБАНК" },
          { "code" => "100000000139", "name" => "КБ ЭНЕРГОТРАНСБАНК" },
          { "code" => "100000000047", "name" => "АКБ Абсолют Банк" },
          { "code" => "100000000146", "name" => "КОШЕЛЕВ-БАНК" },
          { "code" => "100000000124", "name" => "БАНК ОРЕНБУРГ" },
          { "code" => "100000000080", "name" => "АКБ Алмазэргиэнбанк" },
          { "code" => "100000000027", "name" => "Кредит Европа Банк (Россия)" },
          { "code" => "100000000006", "name" => "АК БАРС БАНК" },
          { "code" => "100000000127", "name" => "Хакасский муниципальный банк" },
          { "code" => "100000000053", "name" => "Бланк банк" },
          { "code" => "100000000900", "name" => "ДБО Фактура" },
          { "code" => "100000000020", "name" => "Россельхозбанк" },
          { "code" => "100000000025", "name" => "МОСКОВСКИЙ КРЕДИТНЫЙ БАНК" },
          { "code" => "100000000011", "name" => "РНКБ Банк" },
          { "code" => "100000000044", "name" => "Экспобанк" },
          { "code" => "100000000001", "name" => "Газпромбанк" },
          { "code" => "100000000007", "name" => "Райффайзенбанк" }
        ]
      end

      it "returns sbp banks list" do
        expect(result).to eq(response)
      end
    end
  end
end
