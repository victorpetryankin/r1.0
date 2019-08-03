
#Область СлужебныйПрограммныйИнтерфейс

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.0.13.2";
	Обработчик.Процедура = "Документы.ДивидендыФизическимЛицам.ЗаполнитьРеквизитыКВыплате";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.0.25.76";
	Обработчик.Процедура = "Дивиденды.УточнитьДатуПолученияДоходаВНалогах";

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.1.84";
	Обработчик.Процедура = "Дивиденды.ИсправитьДатыКрайнегоСрокаУплаты";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.1.86";
	Обработчик.Процедура = "Дивиденды.ВыделитьДанныеДля6НДФЛ";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.2.58";
	Обработчик.РежимВыполнения = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОсновнойРежимВыполненияОбновления();
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("1025939d-3cad-4e81-8585-36ec409e68ad");
	Обработчик.Процедура = "Дивиденды.ПроставитьПорядокОтраженияВОтчетностиРасчетовНАсБюджетомПоНДФЛ";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение признака «Исчислено по дивидендам».'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.4.49";
	Обработчик.Процедура = "Дивиденды.УточнитьДвиженияДокументаДивидендыФизическимЛицамПоРегиструСведенияОДоходахНДФЛ";
	Обработчик.РежимВыполнения = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОсновнойРежимВыполненияОбновления();
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("92a5e57c-b1a6-4a83-a5b7-09aa8dd05e3d");
	Обработчик.Комментарий = НСтр("ru = 'Уточнение документа «Дивиденды» по регистру «Учет доходов для исчисления НДФЛ».'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.5.120";
	Обработчик.Процедура = "Дивиденды.ЗаполнитьДвиженияДокументаДивидендыФизическимЛицамПоРегиструУдержания";
	Обработчик.РежимВыполнения = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОсновнойРежимВыполненияОбновления();
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("52009d5e-1e2a-43c7-a070-5057fb10e82b");
	Обработчик.Комментарий = НСтр("ru = 'Заполнить движения документа «Дивиденды» по регистру «Удержания».'");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет объекты, в которых есть процедура ДобавитьКомандыПечати().
// Подробнее см. УправлениеПечатьюПереопределяемый.
//
// Параметры:
//  СписокОбъектов - Массив - список менеджеров объектов.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Документы.ДивидендыФизическимЛицам);
	
КонецПроцедуры

// Обновление ИБ

Процедура ПроставитьПорядокОтраженияВОтчетностиРасчетовНАсБюджетомПоНДФЛ(ПараметрыОбновления = НеОпределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Регистратор
	|ИЗ
	|	РегистрНакопления.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ КАК РасчетыНалоговыхАгентовСБюджетомПоНДФЛ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ДивидендыФизическимЛицам КАК ДивидендыФизическимЛицам
	|		ПО РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Регистратор = ДивидендыФизическимЛицам.Ссылка
	|ГДЕ
	|	ДивидендыФизическимЛицам.Ссылка ЕСТЬ НЕ NULL 
	|	И РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.МесяцНалоговогоПериода >= ДАТАВРЕМЯ(2016, 1, 1, 0, 0, 0)
	|	И НЕ РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ИсчисленоПоДивидендам";
	
	Если ПараметрыОбновления = НеОпределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, " ПЕРВЫЕ 1000", "");
	КонецЕсли;
	
	МассивДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	
	Если МассивДокументов.Количество() = 0 Тогда 
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
	Иначе
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
		
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Период,
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Регистратор КАК Регистратор,
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.НомерСтроки КАК НомерСтроки,
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Активность,
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ВидДвижения,
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ФизическоеЛицо,
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Организация,
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Ставка,
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.МесяцНалоговогоПериода,
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.РеквизитыПлатежногоПоручения,
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.РегистрацияВНалоговомОргане,
		|	ИСТИНА КАК ИсчисленоПоДивидендам,
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ВключатьВДекларациюПоНалогуНаПрибыль,
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Сумма
		|ИЗ
		|	РегистрНакопления.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ КАК РасчетыНалоговыхАгентовСБюджетомПоНДФЛ
		|ГДЕ
		|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Регистратор В(&МассивДокументов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Регистратор,
		|	НомерСтроки";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "РегистрНакопления.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
				Продолжить;
			КонецЕсли;
			
			НаборЗаписей = РегистрыНакопления.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
			Пока Выборка.Следующий() Цикл
				ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
			КонецЦикла;
			НаборЗаписей.Записать();
			
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УточнитьДатуПолученияДоходаВНалогах() Экспорт

	Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор
	|ПОМЕСТИТЬ ВТРегистраторы
	|ИЗ
	|	РегистрНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛ КАК РасчетыНалогоплательщиковСБюджетомПоНДФЛ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДивидендыФизическимЛицам КАК ДивидендыФизическимЛицам
	|		ПО РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор = ДивидендыФизическимЛицам.Ссылка
	|ГДЕ
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Период >= ДАТАВРЕМЯ(2016, 1, 1, 0, 0, 0)
	|	И ДивидендыФизическимЛицам.Ссылка ЕСТЬ НЕ NULL 
	|	И РасчетыНалогоплательщиковСБюджетомПоНДФЛ.МесяцНалоговогоПериода <> ДивидендыФизическимЛицам.ДатаВыплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Период,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор КАК Регистратор,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.НомерСтроки КАК НомерСтроки,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Активность,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВидДвижения,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ГоловнаяОрганизация,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ФизическоеЛицо,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СтавкаНалогообложенияРезидента,
	|	ДивидендыФизическимЛицам.ДатаВыплаты КАК МесяцНалоговогоПериода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.КодДохода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.РегистрацияВНалоговомОргане,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Организация,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СрокПеречисления,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.УдалитьКодДохода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Сумма,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Подразделение,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ДокументОснование,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВариантУдержания,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВключатьВДекларациюПоНалогуНаПрибыль,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.РасчетМежрасчетногоПериода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.УдалитьОрганизация,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СуммаВыплаченногоДохода
	|ИЗ
	|	РегистрНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛ КАК РасчетыНалогоплательщиковСБюджетомПоНДФЛ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДивидендыФизическимЛицам КАК ДивидендыФизическимЛицам
	|		ПО РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор = ДивидендыФизическимЛицам.Ссылка
	|ГДЕ
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор В
	|			(ВЫБРАТЬ
	|				Регистраторы.Регистратор
	|			ИЗ
	|				ВТРегистраторы КАК Регистраторы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор,
	|	НомерСтроки";
	
	УчетНДФЛ.ОбработатьНаборыЗаписейРегистраНакопления("РасчетыНалогоплательщиковСБюджетомПоНДФЛ", Текст)

КонецПроцедуры

Процедура ИсправитьДатыКрайнегоСрокаУплаты() Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор,
	|	ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Период, ДЕНЬ), МЕСЯЦ, 1) КАК СрокУплаты
	|ПОМЕСТИТЬ ВТРегистраторы
	|ИЗ
	|	РегистрНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛ КАК РасчетыНалогоплательщиковСБюджетомПоНДФЛ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДивидендыФизическимЛицам КАК ДивидендыФизическимЛицам
	|		ПО РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор = ДивидендыФизическимЛицам.Ссылка
	|ГДЕ
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.МесяцНалоговогоПериода >= ДАТАВРЕМЯ(2016, 1, 1, 0, 0, 0)
	|	И РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВключатьВДекларациюПоНалогуНаПрибыль
	|	И ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Период, ДЕНЬ), ДЕНЬ, 15) > РасчетыНалогоплательщиковСБюджетомПоНДФЛ.КрайнийСрокУплаты
	|	И РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВариантУдержания = ЗНАЧЕНИЕ(Перечисление.ВариантыУдержанияНДФЛ.Удержано)
	|	И ДивидендыФизическимЛицам.Ссылка ЕСТЬ НЕ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистраторы.СрокУплаты
	|ИЗ
	|	ВТРегистраторы КАК Регистраторы";
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат
	КонецЕсли;
	
	ДатыУдержанияНалога = Результат.Выгрузить().ВыгрузитьКолонку("СрокУплаты");
	РабочиеДни = КалендарныеГрафики.ДатыБлижайшихРабочихДней(КалендарныеГрафики.ПроизводственныйКалендарьРоссийскойФедерации(), ДатыУдержанияНалога, Ложь, Ложь, Истина);
	Если РабочиеДни = Неопределено Тогда 
		 РабочиеДни = Новый Соответствие;
	КонецЕсли;
	
	ТаблицаРабочихДней = Новый ТаблицаЗначений;
	ТаблицаРабочихДней.Колонки.Добавить("ИсходныйДень", Новый ОписаниеТипов("Дата"));
	ТаблицаРабочихДней.Колонки.Добавить("РабочийДень", Новый ОписаниеТипов("Дата"));
	Для каждого Элемент Из РабочиеДни Цикл
		НоваяСтрока = ТаблицаРабочихДней.Добавить();
		НоваяСтрока.ИсходныйДень = Элемент.Ключ;
		НоваяСтрока.РабочийДень = Элемент.Значение;
	КонецЦикла;
	Запрос.УстановитьПараметр("РабочиеДни", ТаблицаРабочихДней);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РабочиеДни.ИсходныйДень,
	|	РабочиеДни.РабочийДень
	|ПОМЕСТИТЬ ВТРабочиеДни
	|ИЗ
	|	&РабочиеДни КАК РабочиеДни";
	Запрос.Выполнить();
	Текст = 
	"ВЫБРАТЬ
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Период,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор КАК Регистратор,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.НомерСтроки КАК НомерСтроки,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Активность,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВидДвижения,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ГоловнаяОрганизация,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ФизическоеЛицо,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СтавкаНалогообложенияРезидента,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.МесяцНалоговогоПериода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.КодДохода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.РегистрацияВНалоговомОргане,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Организация,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Сумма,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Подразделение,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ДокументОснование,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВариантУдержания,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВключатьВДекларациюПоНалогуНаПрибыль,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.РасчетМежрасчетногоПериода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СрокПеречисления,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СуммаВыплаченногоДохода,
	|	ВЫБОР
	|		КОГДА РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВариантУдержания = ЗНАЧЕНИЕ(Перечисление.ВариантыУдержанияНДФЛ.Удержано)
	|			ТОГДА ЕСТЬNULL(РабочиеДни.РабочийДень, ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Период, ДЕНЬ), МЕСЯЦ, 1))
	|		ИНАЧЕ РасчетыНалогоплательщиковСБюджетомПоНДФЛ.КрайнийСрокУплаты
	|	КОНЕЦ КАК КрайнийСрокУплаты
	|ИЗ
	|	РегистрНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛ КАК РасчетыНалогоплательщиковСБюджетомПоНДФЛ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРабочиеДни КАК РабочиеДни
	|		ПО (ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Период, ДЕНЬ), МЕСЯЦ, 1) = РабочиеДни.ИсходныйДень)
	|ГДЕ
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор В
	|			(ВЫБРАТЬ
	|				КОбработке.Регистратор
	|			ИЗ
	|				ВТРегистраторы КАК КОбработке)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор,
	|	НомерСтроки";
	
	УчетНДФЛ.ОбработатьНаборыЗаписейРегистраНакопления("РасчетыНалогоплательщиковСБюджетомПоНДФЛ", Текст, , Запрос.МенеджерВременныхТаблиц);

КонецПроцедуры

Процедура ВыделитьДанныеДля6НДФЛ() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДивидендыФизическимЛицам.Ссылка
	|ПОМЕСТИТЬ ВТРегистраторы
	|ИЗ
	|	Документ.ДивидендыФизическимЛицам КАК ДивидендыФизическимЛицам
	|ГДЕ
	|	ДивидендыФизическимЛицам.ДатаВыплаты >= ДАТАВРЕМЯ(2016, 1, 1, 0, 0, 0)
	|	И ДивидендыФизическимЛицам.Проведен";
	Запрос.Выполнить();

	УчетНДФЛРасширенный.ОтметитьСтрокиДля6НДФЛ(Запрос.МенеджерВременныхТаблиц);

КонецПроцедуры

Процедура УточнитьДвиженияДокументаДивидендыФизическимЛицамПоРегиструСведенияОДоходахНДФЛ(ПараметрыОбновления = Неопределено) Экспорт 
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	НачисленияУдержанияПоКонтрагентамАкционерам.Регистратор КАК Регистратор,
	               |	НачисленияУдержанияПоКонтрагентамАкционерам.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	МАКСИМУМ(НачисленияУдержанияПоКонтрагентамАкционерам.НачислениеУдержание) КАК НачислениеУдержание
	               |ПОМЕСТИТЬ ВТНачисленияУдержания
	               |ИЗ
	               |	РегистрНакопления.НачисленияУдержанияПоКонтрагентамАкционерам КАК НачисленияУдержанияПоКонтрагентамАкционерам
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ДивидендыФизическимЛицам КАК ДивидендыФизическимЛицам
	               |		ПО НачисленияУдержанияПоКонтрагентамАкционерам.Регистратор = ДивидендыФизическимЛицам.Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	НачисленияУдержанияПоКонтрагентамАкционерам.Регистратор,
	               |	НачисленияУдержанияПоКонтрагентамАкционерам.ФизическоеЛицо
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	НачисленияУдержания.НачислениеУдержание КАК Начисление,
	               |	СведенияОДоходахНДФЛ.*
	               |ИЗ
	               |	РегистрНакопления.СведенияОДоходахНДФЛ КАК СведенияОДоходахНДФЛ
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ДивидендыФизическимЛицам КАК ДивидендыФизическимЛицам
	               |		ПО СведенияОДоходахНДФЛ.Регистратор = ДивидендыФизическимЛицам.Ссылка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Перечисление.ВидыОсобыхНачисленийИУдержаний КАК ВидыОсобыхНачисленийИУдержаний
	               |		ПО СведенияОДоходахНДФЛ.Начисление = ВидыОсобыхНачисленийИУдержаний.Ссылка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТНачисленияУдержания КАК НачисленияУдержания
	               |		ПО СведенияОДоходахНДФЛ.Регистратор = НачисленияУдержания.Регистратор
	               |			И СведенияОДоходахНДФЛ.ФизическоеЛицо = НачисленияУдержания.ФизическоеЛицо
	               |ГДЕ
	               |	ВидыОсобыхНачисленийИУдержаний.Ссылка ЕСТЬ NULL
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	СведенияОДоходахНДФЛ.Регистратор";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда 
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл 
		
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "РегистрНакопления.СведенияОДоходахНДФЛ.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыНакопления.СведенияОДоходахНДФЛ.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
		Пока Выборка.Следующий() Цикл 
			НоваяЗапись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
			Если Не ЗначениеЗаполнено(НоваяЗапись.Начисление) Тогда 
				НоваяЗапись.Начисление = Перечисления.ВидыОсобыхНачисленийИУдержаний.Дивиденды;
			КонецЕсли;
		КонецЦикла;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьКатегориюДоходаВДвиженияхДокументаПоРегиструСведенияОДоходахНДФЛ(ПараметрыОбновления = Неопределено) Экспорт 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.КатегорииДоходовНДФЛ.Дивиденды) КАК КатегорияДохода,
	|	ДивидендыФизическимЛицам.Ссылка КАК ДокументОснование,
	|	ЗаписиРегистра.*
	|ИЗ
	|	РегистрНакопления.СведенияОДоходахНДФЛ КАК ЗаписиРегистра
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ДивидендыФизическимЛицам КАК ДивидендыФизическимЛицам
	|		ПО ЗаписиРегистра.Регистратор = ДивидендыФизическимЛицам.Ссылка
	|ГДЕ
	|	ГОД(ДивидендыФизическимЛицам.Дата) >= 2017
	|	И ЗаписиРегистра.КатегорияДохода = ЗНАЧЕНИЕ(Перечисление.КатегорииДоходовНДФЛ.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаписиРегистра.Регистратор,
	|	ЗаписиРегистра.НомерСтроки";
	УчетНДФЛ.ОбработатьНаборыЗаписейРегистраНакопления("СведенияОДоходахНДФЛ", ТекстЗапроса, , , ПараметрыОбновления);
	
КонецПроцедуры

Процедура ЗаполнитьКатегориюДоходаВДвиженияхДокументаПоРегиструРасчетыНалогоплательщиковСБюджетомПоНДФЛ(ПараметрыОбновления = Неопределено) Экспорт 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.КатегорииДоходовНДФЛ.Дивиденды) КАК КатегорияДохода,
	|	ДивидендыФизическимЛицам.Ссылка КАК ДокументОснование,
	|	ЗаписиРегистра.*
	|ИЗ
	|	РегистрНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛ КАК ЗаписиРегистра
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ДивидендыФизическимЛицам КАК ДивидендыФизическимЛицам
	|		ПО ЗаписиРегистра.Регистратор = ДивидендыФизическимЛицам.Ссылка
	|ГДЕ
	|	ГОД(ДивидендыФизическимЛицам.Дата) >= 2017
	|	И ЗаписиРегистра.КатегорияДохода = ЗНАЧЕНИЕ(Перечисление.КатегорииДоходовНДФЛ.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаписиРегистра.Регистратор,
	|	ЗаписиРегистра.НомерСтроки";
	УчетНДФЛ.ОбработатьНаборыЗаписейРегистраНакопления("РасчетыНалогоплательщиковСБюджетомПоНДФЛ", ТекстЗапроса, , , ПараметрыОбновления);
	
КонецПроцедуры

Процедура ИсправитьКатегориюДоходаВУдержанномНДФЛ(ПараметрыОбновления = Неопределено) Экспорт
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор КАК Регистратор
	|ПОМЕСТИТЬ ВТРегистраторы
	|ИЗ
	|	РегистрНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛ КАК РасчетыНалогоплательщиковСБюджетомПоНДФЛ
	|ГДЕ
	|	ГОД(РасчетыНалогоплательщиковСБюджетомПоНДФЛ.МесяцНалоговогоПериода) >= 2017
	|	И РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор ССЫЛКА Документ.ДивидендыФизическимЛицам
	|	И РасчетыНалогоплательщиковСБюджетомПоНДФЛ.КатегорияДохода <> ЗНАЧЕНИЕ(Перечисление.КатегорииДоходовНДФЛ.Дивиденды)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВТРегистраторы.Регистратор КАК Регистратор
	|ИЗ
	|	ВТРегистраторы КАК ВТРегистраторы";
	Если ПараметрыОбновления = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, " ПЕРВЫЕ 1000", "");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Период КАК Период,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор КАК Регистратор,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВидДвижения КАК ВидДвижения,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ФизическоеЛицо КАК ФизическоеЛицо,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СтавкаНалогообложенияРезидента КАК СтавкаНалогообложенияРезидента,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	|	ЗНАЧЕНИЕ(Перечисление.КатегорииДоходовНДФЛ.Дивиденды) КАК КатегорияДохода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Организация КАК Организация,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.КодДохода КАК КодДохода,
	|	СУММА(РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Сумма) КАК Сумма,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Подразделение КАК Подразделение,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ДокументОснование КАК ДокументОснование,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВариантУдержания КАК ВариантУдержания,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВключатьВДекларациюПоНалогуНаПрибыль КАК ВключатьВДекларациюПоНалогуНаПрибыль,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.РасчетМежрасчетногоПериода КАК РасчетМежрасчетногоПериода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СуммаВыплаченногоДохода КАК СуммаВыплаченногоДохода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СрокПеречисления КАК СрокПеречисления,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.КрайнийСрокУплаты КАК КрайнийСрокУплаты,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.УчитыватьВыплаченныйДоходВ6НДФЛ КАК УчитыватьВыплаченныйДоходВ6НДФЛ,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ДатаПолученияДоходаФиксирована КАК ДатаПолученияДоходаФиксирована,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.УстаревшаяДатаПолученияДохода КАК УстаревшаяДатаПолученияДохода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Сторно КАК Сторно
	|ИЗ
	|	РегистрНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛ КАК РасчетыНалогоплательщиковСБюджетомПоНДФЛ
	|ГДЕ
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор В
	|			(ВЫБРАТЬ 
	|				Регистраторы.Регистратор
	|			ИЗ
	|				ВТРегистраторы КАК Регистраторы)
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.УчитыватьВыплаченныйДоходВ6НДФЛ,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СрокПеречисления,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Подразделение,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.КрайнийСрокУплаты,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.РегистрацияВНалоговомОргане,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ГоловнаяОрганизация,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ФизическоеЛицо,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВидДвижения,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Период,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СтавкаНалогообложенияРезидента,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.МесяцНалоговогоПериода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВключатьВДекларациюПоНалогуНаПрибыль,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.РасчетМежрасчетногоПериода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.КодДохода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Организация,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВариантУдержания,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ДатаПолученияДоходаФиксирована,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Сторно,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.УстаревшаяДатаПолученияДохода,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ДокументОснование,
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СуммаВыплаченногоДохода
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "РегистрНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛ.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛ.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьДвиженияДокументаДивидендыФизическимЛицамПоРегиструУдержания(ПараметрыОбновления = Неопределено) Экспорт
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НачисленияУдержанияПоКонтрагентамАкционерам.Регистратор КАК Регистратор
	|ПОМЕСТИТЬ ВТРегистраторы
	|ИЗ
	|	РегистрНакопления.НачисленияУдержанияПоКонтрагентамАкционерам КАК НачисленияУдержанияПоКонтрагентамАкционерам
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.Удержания КАК Удержания
	|		ПО НачисленияУдержанияПоКонтрагентамАкционерам.Регистратор = Удержания.Регистратор
	|ГДЕ
	|	НачисленияУдержанияПоКонтрагентамАкционерам.НачислениеУдержание ССЫЛКА ПланВидовРасчета.Удержания
	|	И НачисленияУдержанияПоКонтрагентамАкционерам.Регистратор ССЫЛКА Документ.ДивидендыФизическимЛицам
	|	И Удержания.Регистратор ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК Поле1
	|ИЗ
	|	ВТРегистраторы КАК ВТРегистраторы";
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда 
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДивидендыФизическимЛицамУдержания.Ссылка КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(ДивидендыФизическимЛицамУдержания.Ссылка.ПериодРегистрации, МЕСЯЦ) КАК ПериодРегистрации,
	|	ДивидендыФизическимЛицамУдержания.Ссылка.ДатаВыплаты КАК ПланируемаяДатаВыплаты,
	|	ДивидендыФизическимЛицамУдержания.Ссылка.Организация КАК Организация,
	|	ДивидендыФизическимЛицамУдержания.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДивидендыФизическимЛицамУдержания.Результат КАК Результат,
	|	ДивидендыФизическимЛицамУдержания.Удержание КАК ВидРасчета,
	|	ДивидендыФизическимЛицамУдержания.ДокументОснование КАК ДокументОснование,
	|	ДивидендыФизическимЛицамУдержания.Получатель КАК Получатель,
	|	ДивидендыФизическимЛицамУдержания.ПлатежныйАгент КАК ПлатежныйАгент,
	|	ДивидендыФизическимЛицамУдержания.ДатаНачала КАК БазовыйПериодНачало,
	|	ДивидендыФизическимЛицамУдержания.ДатаОкончания КАК БазовыйПериодКонец,
	|	ДивидендыФизическимЛицамУдержания.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Документ.ДивидендыФизическимЛицам.Удержания КАК ДивидендыФизическимЛицамУдержания
	|ГДЕ
	|	ДивидендыФизическимЛицамУдержания.Ссылка В
	|			(ВЫБРАТЬ
	|				Регистраторы.Регистратор
	|			ИЗ
	|				ВТРегистраторы КАК Регистраторы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор,
	|	НомерСтроки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
		
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "РегистрРасчета.Удержания.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыРасчета.Удержания.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
		
		ГоловнаяОрганизация = ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(Выборка.Организация);
		
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.Организация = ГоловнаяОрганизация;
			НоваяСтрока.ПериодДействияНачало = НачалоМесяца(Выборка.ПериодРегистрации);
			НоваяСтрока.ПериодДействияКонец = КонецМесяца(Выборка.ПериодРегистрации);
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;
	
КонецПроцедуры

// Проверяет наличие записей в регистре взаиморасчетов с контрагентами,
// зарегистрированных документом ДивидендыФизическимЛицам.
//
//	Возвращаемое значение - тип Булево, Истина, если в регистре есть записи
//
Функция НельзяВыключитьИспользованиеВедомостей() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Взаиморасчеты.НомерСтроки
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСКонтрагентамиАкционерами КАК Взаиморасчеты
	|ГДЕ
	|	Взаиморасчеты.Регистратор ССЫЛКА Документ.ДивидендыФизическимЛицам";
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();

КонецФункции 

#КонецОбласти