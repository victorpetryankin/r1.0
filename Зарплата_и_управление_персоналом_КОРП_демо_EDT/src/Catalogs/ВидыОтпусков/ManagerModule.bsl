#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПараметрыВыбораВидаОтпуска() Экспорт
	
	ПараметрыВыбора = Новый Структура(
		"Отбор_ОтпускЯвляетсяЕжегодным,
		|Отбор_ОтпускБезОплаты, 
		|Дополнительно_СоздаватьНачисления, 
		|Отбор_ИсключатьОтпускНаСанаторноКурортноеЛечение");
	
	ПараметрыВыбора.Отбор_ОтпускЯвляетсяЕжегодным = Истина;
	ПараметрыВыбора.Отбор_ОтпускБезОплаты = Ложь;
	ПараметрыВыбора.Отбор_ИсключатьОтпускНаСанаторноКурортноеЛечение = Истина;
	ПараметрыВыбора.Дополнительно_СоздаватьНачисления = Ложь;
	
	Возврат ПараметрыВыбора;
	
КонецФункции

#Область БлокФункцийПервоначальногоЗаполненияИОбновленияИБ

// Процедура создает виды отпусков в зависимости от настроек расчета зарплаты.
//  Параметры: 
//		ПараметрыПланаВидовРасчета - см. РасчетЗарплатыРасширенный.ОписаниеПараметровПланаВидовРасчета.
//
Процедура СоздатьВидыОтпусковПоНастройкам(ПараметрыПланаВидовРасчета = Неопределено, НастройкиРасчетаЗарплаты = Неопределено) Экспорт
	
	Если ПараметрыПланаВидовРасчета = Неопределено Тогда
		ПараметрыПланаВидовРасчета = РасчетЗарплатыРасширенный.ОписаниеПараметровПланаВидовРасчета();
	КонецЕсли;
	
	Если НастройкиРасчетаЗарплаты = Неопределено Тогда
		НастройкиРасчетаЗарплаты = РасчетЗарплатыРасширенный.НастройкиРасчетаЗарплаты();
	КонецЕсли;
	
	ИспользоватьОтпускаБезОплаты = НастройкиРасчетаЗарплаты.ИспользоватьОтпускаБезОплаты 
									Или Константы.НеИспользоватьНачислениеЗарплаты.Получить();
	
	Если ИспользоватьОтпускаБезОплаты Тогда
		
		ОбновитьПовторноИспользуемыеЗначения();
		
		// Отпуск без оплаты согласно ТК РФ (отпустить обязаны).
		ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
		ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
		ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускБезОплатыПоТКРФ";
		ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Отпуск без оплаты в соотв. с частью 2 статьи 128 ТК РФ'");
		ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Отпуск без оплаты в соотв. с частью 2 статьи 128 ТК РФ'");
		ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
		ОписаниеВидаОтпуска.ОтпускБезОплаты				= Истина;
		
		НовыйВидОтпуска(ОписаниеВидаОтпуска);
		
		// Отпуск за свой счет (требуется согласие администрации).
		ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
		ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
		ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускЗаСвойСчет";
		ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Отпуск без оплаты в соотв. с частью 1 статьи 128 ТК РФ'");
		ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Отпуск без оплаты в соотв. с частью 1 статьи 128 ТК РФ'");
		ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
		ОписаниеВидаОтпуска.ОтпускБезОплаты				= Истина;
		
		НовыйВидОтпуска(ОписаниеВидаОтпуска);
		
		// Дополнительный учебный отпуск без оплаты.
		ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
		ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
		ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускБезОплатыУчебный";
		ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Дополнительный учебный отпуск без оплаты'");
		ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Дополнительный учебный отпуск без оплаты'");
		ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
		ОписаниеВидаОтпуска.ОтпускБезОплаты				= Истина;
		
		НовыйВидОтпуска(ОписаниеВидаОтпуска);
		
	КонецЕсли;
	
	ОбновитьИспользуемостьВидаОтпуска("ОтпускБезОплатыПоТКРФ", ИспользоватьОтпускаБезОплаты);
	ОбновитьИспользуемостьВидаОтпуска("ОтпускЗаСвойСчет", ИспользоватьОтпускаБезОплаты);
	ОбновитьИспользуемостьВидаОтпуска("ОтпускБезОплатыУчебный", ИспользоватьОтпускаБезОплаты);
	
	Если НастройкиРасчетаЗарплаты.ИспользоватьОтпускаУчебные Тогда
		// Учебный отпуск (оплачиваемый).
		ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
		ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
		ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускУчебный";
		ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Дополнительный учебный отпуск (оплачиваемый)'");
		ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Дополнительный учебный отпуск (оплачиваемый)'");
		ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
		ОписаниеВидаОтпуска.ОтпускБезОплаты				= Ложь;
		ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным		= Ложь;
		НовыйВидОтпуска(ОписаниеВидаОтпуска);
	КонецЕсли;
	ОбновитьИспользуемостьВидаОтпуска("ОтпускУчебный", НастройкиРасчетаЗарплаты.ИспользоватьОтпускаУчебные);
	
	Если НастройкиРасчетаЗарплаты.ИспользоватьОтпускаДляПострадавшихВАварииЧАЭС Тогда
		// Дополнительный отпуск пострадавшим в аварии на ЧАЭС.
		ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
		ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
		ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускПострадавшимВАварииЧАЭС";
		ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Дополнительный отпуск пострадавшим на ЧАЭС'");
		ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Дополнительный отпуск пострадавшим в аварии на ЧАЭС'");
		ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
		ОписаниеВидаОтпуска.КоличествоДнейВГод			= 14;
		ОписаниеВидаОтпуска.ОтпускБезОплаты				= Истина;
		ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным		= Истина;
		НовыйВидОтпуска(ОписаниеВидаОтпуска);
	КонецЕсли;
	ОбновитьИспользуемостьВидаОтпуска("ОтпускПострадавшимВАварииЧАЭС", НастройкиРасчетаЗарплаты.ИспользоватьОтпускаДляПострадавшихВАварииЧАЭС);
	
	// Отпуск за вредные условия труда.
	СоздатьВидОтпускаЗаВредныеУсловияТруда(НастройкиРасчетаЗарплаты);	
	
	ДополнительныеОтпуска = ПараметрыПланаВидовРасчета.ДополнительныеОтпуска;
	Для каждого ДополнительныйОтпуск Из ДополнительныеОтпуска.ДополнительныеОтпуска Цикл
		
		НаименованиеОтпуска = СОКРЛП(ДополнительныйОтпуск.Наименование);
		Если ПустаяСтрока(НаименованиеОтпуска) Тогда
			Продолжить;
		КонецЕсли;
		
		ОтпускСсылка = Справочники.ВидыОтпусков.НайтиПоНаименованию(НаименованиеОтпуска, Истина);
		Если ОтпускСсылка.Пустая() Тогда
			ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
			ОписаниеВидаОтпуска.Наименование			= НаименованиеОтпуска;
			ОписаниеВидаОтпуска.НаименованиеПолное		= НаименованиеОтпуска;
			ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным = ДополнительныйОтпуск.ОтпускЯвляетсяЕжегодным;
			ОписаниеВидаОтпуска.ПредоставлятьОтпускВсемСотрудникам = ДополнительныйОтпуск.ПредоставлятьОтпускВсемСотрудникам;
			ОписаниеВидаОтпуска.КоличествоДнейВГод = ДополнительныйОтпуск.КоличествоДнейВГод;
			ОписаниеВидаОтпуска.СпособРасчетаОтпуска = Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
			ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска = Ложь;
			ОтпускОбъект = НовыйВидОтпуска(ОписаниеВидаОтпуска);
			ОтпускСсылка = ОтпускОбъект.Ссылка;
		КонецЕсли;
		
		ДополнительныйОтпуск.ВидОтпуска = ОтпускСсылка;
		
	КонецЦикла;
	
	НастройкиПрограммы = ЗарплатаКадрыРасширенный.НастройкиПрограммыБюджетногоУчреждения();
	
	Если НастройкиПрограммы.РаботаВБюджетномУчреждении И (НастройкиПрограммы.ИспользоватьГосударственнуюСлужбу Или НастройкиПрограммы.ИспользоватьМуниципальнуюСлужбу) Тогда
		
		// отпуска за выслугу лет
		ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
		ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска			= Истина;
		ОписаниеВидаОтпуска.ИмяПредопределенныхДанных			= "ОтпускЗаВыслугуЛетНаГосударственнойСлужбе";
		Если НастройкиПрограммы.ИспользоватьГосударственнуюСлужбу Тогда
			ОписаниеВидаОтпуска.Наименование						= НСтр("ru = 'За выслугу лет на гос. службе'");
			ОписаниеВидаОтпуска.НаименованиеПолное					= НСтр("ru = 'Отпуск за выслугу лет на гос. службе'");
		Иначе
			ОписаниеВидаОтпуска.Наименование						= НСтр("ru = 'За выслугу лет на муниц. службе'");
			ОписаниеВидаОтпуска.НаименованиеПолное					= НСтр("ru = 'Отпуск за выслугу лет на муниц. службе'");
		КонецЕсли;
		ОписаниеВидаОтпуска.СпособРасчетаОтпуска				= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхИлиРабочихДняхВЗависимостиОтТрудовогоДоговора;
		ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным				= Истина;
		ОписаниеВидаОтпуска.ПредоставлятьОтпускВсемСотрудникам	= Ложь;
		ОписаниеВидаОтпуска.КоличествоДнейВГод					= 0;
		ОписаниеВидаОтпуска.ХарактерЗависимостиДнейОтпуска = ПредопределенноеЗначение("Перечисление.ХарактерЗависимостиКоличестваДнейОтпуска.ЗависитОтСтажа");
		СтажиГосслужащих = Справочники.ВидыСтажа.ВидыСтажаПоКатегории(Перечисления.КатегорииСтажа.ВыслугаЛетНаГосударственнойСлужбе);
		Если СтажиГосслужащих.Количество() > 0 Тогда
			ОписаниеВидаОтпуска.ВидСтажа						= СтажиГосслужащих[0];
		КонецЕсли;
		
		НовыйОтпуск = НовыйВидОтпуска(ОписаниеВидаОтпуска);
		
		// Заполняем шкалу стажа.
		ТаблицаШкалы = НовыйОтпуск.ШкалаОценкиСтажа;
		ТаблицаШкалы.Очистить();
		Для СчЛет = 1 По 10 Цикл
			НоваяСтрока = ТаблицаШкалы.Добавить();
			НоваяСтрока.ВерхняяГраницаИнтервалаСтажа = СчЛет*12;
			НоваяСтрока.КоличествоДнейВГод = СчЛет-1;
		КонецЦикла; 
		НоваяСтрока = ТаблицаШкалы.Добавить();
		НоваяСтрока.ВерхняяГраницаИнтервалаСтажа = 0;
		НоваяСтрока.КоличествоДнейВГод = 10;
		
		НовыйОтпуск.Записать();
		
	КонецЕсли;
		
КонецПроцедуры

Процедура СоздатьВидОтпускаЗаВредныеУсловияТруда(НастройкиРасчетаЗарплаты) Экспорт
	
	Если НастройкиРасчетаЗарплаты.ИспользоватьНадбавкуЗаВредность Тогда
		ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
		ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
		ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускЗаВредность";
		ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Отпуск за вредность'");
		ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Отпуск за вредность'");
		ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
		ОписаниеВидаОтпуска.ХарактерЗависимостиДнейОтпуска = ПредопределенноеЗначение("Перечисление.ХарактерЗависимостиКоличестваДнейОтпуска.ЗависитОтРабочегоМеста");
		ОписаниеВидаОтпуска.ОтпускБезОплаты				= Ложь;
		ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным		= Истина;
		ОписаниеВидаОтпуска.ПредоставлятьОтпускВсемСотрудникам	= Ложь;
		ОписаниеВидаОтпуска.КоличествоДнейВГод			= 0;
		НовыйВидОтпуска(ОписаниеВидаОтпуска);
	КонецЕсли;
	ОбновитьИспользуемостьВидаОтпуска("ОтпускЗаВредность", НастройкиРасчетаЗарплаты.ИспользоватьНадбавкуЗаВредность);
	
КонецПроцедуры

Процедура ЗаполнитьСпособРасчетаВидовОтпуска() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыОтпусков.Ссылка
	|ИЗ
	|	Справочник.ВидыОтпусков КАК ВидыОтпусков
	|ГДЕ
	|	ВидыОтпусков.СпособРасчетаОтпуска = ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаОтпуска.ПустаяСсылка)";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВидОтпуска = Выборка.Ссылка.ПолучитьОбъект();
		ВидОтпуска.СпособРасчетаОтпуска = Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
		ВидОтпуска.ОбменДанными.Загрузка = Истина;
		ВидОтпуска.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

Функция КоличествоВидовОтпуска() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВидыОтпусков.Ссылка) КАК Количество
	|ИЗ
	|	Справочник.ВидыОтпусков КАК ВидыОтпусков
	|ГДЕ
	|	ВидыОтпусков.Предопределенный = ЛОЖЬ");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Количество;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	КадровыйУчетРасширенныйВызовСервера.ОбработкаПолученияДанныхВыбораСправочникаВидыОтпусков(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Или ВидФормы = "ФормаСписка" Тогда
		ПараметрИзменен = Ложь;
		
		Если Не Параметры.Свойство("Отбор") Тогда
			Параметры.Вставить("Отбор", Новый Структура("Недействителен", Ложь));
			ПараметрИзменен = Истина;
		ИначеЕсли Не Параметры.Отбор.Свойство("Недействителен") Тогда
			Параметры.Отбор.Вставить("Недействителен", Ложь);
			ПараметрИзменен = Истина;
		КонецЕсли;
		
		// Этот код нужен, чтобы были использованы измененные нами значения параметров.
		Если ПараметрИзменен Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаСписка"; // передаем имя формы выбора
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПустоеОписаниеВидаОтпуска()
	
	Возврат Новый Структура("
	|Наименование,
	|НаименованиеПолное,
	|ОтпускБезОплаты,
	|ОтпускЯвляетсяЕжегодным,
	|ПредоставлятьОтпускВсемСотрудникам,
	|КоличествоДнейВГод,
	|СпособРасчетаОтпуска,
	|ПредопределенныйВидОтпуска,
	|ИмяПредопределенныхДанных,
	|ХарактерЗависимостиДнейОтпуска,
	|ВидСтажа,
	|ОсновнойОтпуск");
	
КонецФункции

Функция НовыйВидОтпуска(ОписаниеВидаОтпуска)
	
	ВидОтпускаОбъект = Неопределено;
	Если ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска Тогда 
		ВидОтпускаСсылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков." + ОписаниеВидаОтпуска.ИмяПредопределенныхДанных);
		Если ВидОтпускаСсылка <> Неопределено Тогда 
			ВидОтпускаОбъект = ВидОтпускаСсылка.ПолучитьОбъект();
			Возврат ВидОтпускаОбъект;
		КонецЕсли;
	КонецЕсли;
	
	Если ВидОтпускаОбъект = Неопределено Тогда 
		ВидОтпускаОбъект = Справочники.ВидыОтпусков.СоздатьЭлемент();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ВидОтпускаОбъект, ОписаниеВидаОтпуска);
	ВидОтпускаОбъект.Записать();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат ВидОтпускаОбъект;
	
КонецФункции

Процедура ОбновитьИспользуемостьВидаОтпуска(ИмяПредопределенныхДанных, Действителен)
	
	ВидОтпускаСсылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков." + ИмяПредопределенныхДанных);
	
	Если ВидОтпускаСсылка <> Неопределено Тогда 
		ВидОтпускаОбъект = ВидОтпускаСсылка.ПолучитьОбъект();
		ВидОтпускаОбъект.Недействителен = Не Действителен;
		ВидОтпускаОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает используемость Северного отпуска.
//
Процедура ОбновитьИспользуемостьСеверногоОтпуска(Действителен) Экспорт
	
	ОбновитьИспользуемостьВидаОтпуска("Северный", Действителен);
	
КонецПроцедуры

// Процедура производит первоначальное заполнение предопределенных видов отпуска.
Процедура ОписатьВидОтпускаОсновнойОтпуск() Экспорт

	ОбновитьПовторноИспользуемыеЗначения();
	
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска			= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных			= "Основной";
	ОписаниеВидаОтпуска.Наименование						= НСтр("ru = 'Основной'");
	ОписаниеВидаОтпуска.НаименованиеПолное					= НСтр("ru = 'Основной отпуск'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска				= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхИлиРабочихДняхВЗависимостиОтТрудовогоДоговора;
	ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным				= Истина;
	ОписаниеВидаОтпуска.ПредоставлятьОтпускВсемСотрудникам	= Истина;
	ОписаниеВидаОтпуска.КоличествоДнейВГод					= 28;
	ОписаниеВидаОтпуска.ОсновнойОтпуск						= Истина;
	
	НовыйВидОтпуска(ОписаниеВидаОтпуска);
	
КонецПроцедуры

// Процедура производит первоначальное заполнение предопределенных видов отпуска.
Процедура ОписатьВидОтпускаСеверныйОтпуск(Действителен = Неопределено) Экспорт
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если Действителен = Неопределено Тогда
		Действителен = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.Северный") <> Неопределено;
	КонецЕсли;	
	
	Если Действителен Тогда
		
		ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
		ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
		ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "Северный";
		ОписаниеВидаОтпуска.Наименование 				= НСтр("ru = 'Северный'");
		ОписаниеВидаОтпуска.НаименованиеПолное 			= НСтр("ru = 'Северный'");
		ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
		ОписаниеВидаОтпуска.ХарактерЗависимостиДнейОтпуска = ПредопределенноеЗначение("Перечисление.ХарактерЗависимостиКоличестваДнейОтпуска.ЗависитОтРабочегоМеста");
		ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным 	= Истина;
		ОписаниеВидаОтпуска.КоличествоДнейВГод 			= 0;
		
		НовыйВидОтпуска(ОписаниеВидаОтпуска);
		
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.Северный") <> Неопределено Тогда 
		Справочники.ВидыОтпусков.ОбновитьИспользуемостьСеверногоОтпуска(Действителен);		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОписатьВидОтпускаДополнительныйОтпускНаСанаторноКурортноеЛечение() Экспорт
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускНаСанаторноКурортноеЛечение";
	ОписаниеВидаОтпуска.Наименование 				= НСтр("ru = 'Отпуск на период санаторно-курортного лечения (за счет ФСС)'");
	ОписаниеВидаОтпуска.НаименованиеПолное 			= НСтр("ru = 'Отпуск на СКЛ (за счет ФСС)'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
	ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным 	= Ложь;
	
	НовыйВидОтпуска(ОписаниеВидаОтпуска);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
