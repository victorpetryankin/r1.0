
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, ДатаСобытия", 
			"Объект.Организация", "Объект.Ответственный", "Объект.ДатаНачала");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		РасчетЗарплатыРасширенныйФормы.ЗаполнитьУдержаниеВФормеДокументаПоРоли(
			ЭтаФорма, 
			Объект.Удержание, 
			Перечисления.КатегорииУдержаний.УдержаниеВСчетРасчетовПоПрочимОперациям, 
			Новый Структура("СпособВыполненияУдержания", Перечисления.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете));
		Если ЗначениеЗаполнено(Объект.Удержание) Тогда
			УдержаниеДействует = РасчетЗарплатыРасширенныйФормы.УдержаниеДействуетНаДату(
				Объект.Организация, Объект.ФизическоеЛицо, Объект.Удержание, Объект.ДатаНачала, Объект.Ссылка, Объект.ДокументОснование);
			РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийЗаполнитьПоказатели(ЭтаФорма);
		КонецЕсли;
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗарплатаКадрыРасширенный.УстановитьПредставлениеРабочихМест(ЭтотОбъект);	

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Организация", Объект.Организация);
	ПараметрыОповещения.Вставить("ФизическоеЛицо", Объект.ФизическоеЛицо);
	
	Оповестить("ИзменилсяСоставУдержанийСотрудника", ПараметрыОповещения, ЭтаФорма);
	Оповестить("Запись_УдержаниеВСчетРасчетовПоПрочимОперациям", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	
	ФизическоеЛицоПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	ДатаНачалаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УдержаниеПриИзменении(Элемент)
	УдержаниеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДействиеПриИзменении(Элемент)
	ДействиеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеРабочегоМестаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПредставлениеРабочегоМестаНачалоВыбораНаСервере(Объект.ФизическоеЛицо, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеРабочегоМестаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЗарплатаКадрыРасширенныйКлиент.РабочиеМестаУдержанийОбработкаВыбораРабочегоМеста(ЭтотОбъект, Объект, ВыбранноеЗначение, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура БухучетЗаданВДокументеПриИзменении(Элемент)
	
	Если Объект.БухучетЗаданВДокументе Тогда
		Объект.СтатьяФинансирования = СтатьяФинансированияПрошлоеЗначение;
		Объект.СтатьяРасходов 		= СтатьяРасходовПрошлоеЗначение;
	Иначе
		СтатьяФинансированияПрошлоеЗначение = Объект.СтатьяФинансирования;
		Объект.СтатьяФинансирования = "";
		СтатьяРасходовПрошлоеЗначение = Объект.СтатьяРасходов;
		Объект.СтатьяРасходов = "";
	КонецЕсли;
	ОбновитьДоступностьНастроекБухучета(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрекратитьПоДостижениюПределаПриИзменении(Элемент)
	
	УстановитьДоступностьПредела(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ЗарплатаКадрыРасширенный.УстановитьВидимостьПредставленияРабочегоМеста(ЭтотОбъект);
	ЗарплатаКадрыРасширенный.УстановитьПредставлениеРабочихМест(ЭтотОбъект);
	
	РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийУстановитьВидимостьПоказателей(Элементы, Объект.Удержание);
	РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийУстановитьВидимостьРазмера(Элементы, Объект.Удержание);
	
	РасчетЗарплатыРасширенныйФормы.УстановитьВидимостьВыбораВидаДействия(ЭтотОбъект);
	
	УдержаниеДействует = РасчетЗарплатыРасширенныйФормы.УдержаниеДействуетНаДату(
		Объект.Организация, Объект.ФизическоеЛицо, Объект.Удержание, Объект.ДатаНачала, Объект.Ссылка, Объект.ДокументОснование);
	
	РасчетЗарплатыРасширенныйФормы.УстановитьСтраницуДействия(ЭтотОбъект);
	УстановитьДоступностьПоляДатаОкончания();
	УстановитьДоступностьПредела(ЭтотОбъект);
	
	УстановитьДоступностьНастроекБухучета();
	СтатьяФинансированияПрошлоеЗначение = Объект.СтатьяФинансирования;
	СтатьяРасходовПрошлоеЗначение 		= Объект.СтатьяРасходов;
	ОбновитьДоступностьНастроекБухучета(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПоляДатаОкончания()
	
	Если Объект.Действие = Перечисления.ДействияСУдержаниями.Изменить Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИзменитьОтменитьГруппа", "ТекущаяСтраница", Элементы.ИзменитьГруппа);
	ИначеЕсли Объект.Действие = Перечисления.ДействияСУдержаниями.Прекратить Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИзменитьОтменитьГруппа", "ТекущаяСтраница", Элементы.ПрекратитьГруппа);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьДействиеИПоказатели();
	ЗарплатаКадрыРасширенный.УстановитьВидимостьПредставленияРабочегоМеста(ЭтотОбъект);
	ЗарплатаКадрыРасширенный.УстановитьПредставлениеРабочихМест(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ФизическоеЛицоПриИзмененииНаСервере()
	
	ЗаполнитьДействиеИПоказатели();
	
	ЗарплатаКадрыРасширенный.РабочиеМестаУдержанийПриИзмененииФизическогоЛицаВШапке(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ДатаНачалаПриИзмененииНаСервере()
	
	ЗарплатаКадрыРасширенный.УстановитьВидимостьПредставленияРабочегоМеста(ЭтотОбъект);
	ЗаполнитьДействиеИПоказатели();
	
КонецПроцедуры

&НаСервере
Процедура УдержаниеПриИзмененииНаСервере()
	
	ЗаполнитьДействиеИПоказатели();
	УстановитьДоступностьНастроекБухучета();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДействиеИПоказатели()
	
	РасчетЗарплатыРасширенныйФормы.УстановитьВидимостьВыбораВидаДействия(ЭтаФорма);
	РасчетЗарплатыРасширенныйФормы.ЗаполнитьДействиеИПоказатели(ЭтаФорма, Объект.ДокументОснование);
	РасчетЗарплатыРасширенныйФормы.ЗаполнитьПределУдержания(Объект, Объект.ДокументОснование);
	УстановитьДоступностьПредела(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ДействиеПриИзмененииНаСервере()
	
	ЗаполнитьДействиеИПоказатели();
	РасчетЗарплатыРасширенныйФормы.УстановитьДоступностьДокументаОснования(ЭтаФорма);
	УстановитьДоступностьПоляДатаОкончания();
	УстановитьДоступностьНастроекБухучета();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	ЗаполнитьДействиеИПоказатели();
КонецПроцедуры

&НаСервере
Процедура ПредставлениеРабочегоМестаНачалоВыбораНаСервере(ФизическоеЛицо, ДанныеВыбора, СтандартнаяОбработка) 
	
	ЗарплатаКадрыРасширенный.РабочиеМестаУдержанийНачалоВыбораРабочегоМеста(ЭтотОбъект, ФизическоеЛицо, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОбновитьДоступностьНастроекБухучета(Форма)
	
	НастройкаДоступна = Форма.Объект.БухучетЗаданВДокументе;
	Элементы = Форма.Элементы;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяФинансирования", "Доступность", НастройкаДоступна);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяФинансирования", "АвтоОтметкаНезаполненного", НастройкаДоступна);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяФинансирования", "ОтметкаНезаполненного", НастройкаДоступна И Не ЗначениеЗаполнено(Форма.Объект.СтатьяФинансирования));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяРасходов", "Доступность", НастройкаДоступна);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяРасходов", "АвтоОтметкаНезаполненного", НастройкаДоступна);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяРасходов", "ОтметкаНезаполненного", НастройкаДоступна И Не ЗначениеЗаполнено(Форма.Объект.СтатьяРасходов));
	
КонецФункции

&НаСервере
Процедура УстановитьДоступностьНастроекБухучета()

	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") Тогда
		
		НастройкаДоступна = Объект.Действие <> Перечисления.ДействияСУдержаниями.Прекратить;
		Если НастройкаДоступна Тогда
			НастройкаДоступна = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Удержание, "ДоступнаСтратегияОтраженияКакЗаданоВидуРасчета");
			НастройкаДоступна = ?(НастройкаДоступна = Неопределено, Ложь, НастройкаДоступна);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "БухучетГруппа", "Видимость", НастройкаДоступна);
		Если Не НастройкаДоступна Тогда
			Объект.БухучетЗаданВДокументе = Ложь;
			Объект.СтатьяФинансирования = "";
			Объект.СтатьяРасходов = "";
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьПредела(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Предел", "Доступность", Объект.ПрекратитьПоДостижениюПредела);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Предел", "АвтоОтметкаНезаполненного", Объект.ПрекратитьПоДостижениюПредела);
	
	Если Не Объект.ПрекратитьПоДостижениюПредела Тогда
		Объект.Предел = 0;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
