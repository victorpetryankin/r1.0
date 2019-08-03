
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение классификатора.
Процедура НачальноеЗаполнение() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтрокиОтчетности.Ссылка
	|ИЗ
	|	Справочник.СтрокиОтчетностиРасходовИЧисленностиРаботниковГосударственныхОрганов КАК СтрокиОтчетности");
	
	Если Не Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.Code КАК СТРОКА(11)) КАК Код,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.Name КАК СТРОКА(150)) КАК Наименование,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.CategoryCode КАК СТРОКА(50)) КАК КодКатегорииПерсонала,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.ReportForm КАК СТРОКА(50)) КАК ФормаОтчета,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.Comment КАК СТРОКА(300)) КАК Пояснение
	|ПОМЕСТИТЬ СтрокиОтчетностиТаблица
	|ИЗ
	|	&СтрокиОтчетностиТаблица КАК СтрокиОтчетностиТаблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтрокиОтчетностиТаблица.Код,
	|	СтрокиОтчетностиТаблица.Наименование,
	|	СтрокиОтчетностиТаблица.КодКатегорииПерсонала,
	|	СтрокиОтчетностиТаблица.ФормаОтчета,
	|	СтрокиОтчетностиТаблица.Пояснение
	|ИЗ
	|	СтрокиОтчетностиТаблица КАК СтрокиОтчетностиТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтрокиОтчетностиРасходовИЧисленностиРаботниковГосударственныхОрганов КАК СтрокиОтчетности
	|		ПО СтрокиОтчетностиТаблица.Код = СтрокиОтчетности.Код
	|ГДЕ
	|	СтрокиОтчетности.Ссылка ЕСТЬ NULL ");
	
	ТекстовыйДокумент = Справочники.СтрокиОтчетностиРасходовИЧисленностиРаботниковГосударственныхОрганов.ПолучитьМакет("СтрокиОтчетностиРасходовИЧисленности");
	Таблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ТекстовыйДокумент.ПолучитьТекст()).Данные;
	
	Запрос.УстановитьПараметр("СтрокиОтчетностиТаблица", Таблица);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СправочникОбъект = Справочники.СтрокиОтчетностиРасходовИЧисленностиРаботниковГосударственныхОрганов.СоздатьЭлемент();
		СправочникОбъект.Код = СокрЛП(Выборка.Код);
		СправочникОбъект.Наименование = СокрЛП(Выборка.Наименование);
		СправочникОбъект.КодКатегорииПерсонала = СокрЛП(Выборка.КодКатегорииПерсонала);
		СправочникОбъект.Пояснение = СокрЛП(Выборка.Пояснение);
		
		Если СокрЛП(Выборка.ФормаОтчета) = "Форма14" Тогда
			СправочникОбъект.ФормаОтчета = Перечисления.ВидыФормОтчетовОРасходахИЧисленностиРаботниковГосударственныхОрганов.Форма14;
		ИначеЕсли СокрЛП(Выборка.ФормаОтчета) = "Форма14МО" Тогда
			СправочникОбъект.ФормаОтчета = Перечисления.ВидыФормОтчетовОРасходахИЧисленностиРаботниковГосударственныхОрганов.Форма14МО;
		КонецЕсли;
		
		СправочникОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		СправочникОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
// Используется для сопоставления элементов механизмом «Выгрузка/загрузка областей данных».
//
// Возвращаемое значение: Массив(Строка) - массив имен реквизитов, образующих
//  естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Код");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
