
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Объект.Ссылка.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура(
			"Организация, Ответственный", "Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Объект.ДатаИзменения = ТекущаяДатаСеанса();
		
		ЗаполнитьДанныеФормыПоОрганизации();
		ПриПолученииДанныхНаСервере();
		
		Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			УстановитьТекущиеДанныеСотрудника();
			УстановитьОтображениеНадписей();
		КонецЕсли; 
		
	КонецЕсли;
	
	ЭтаФорма.Заголовок = РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("ИзменениеРазрядаЭлемент");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"РазрядКатегория",
		"Заголовок",
		РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("РеквизитРазрядКатегорияВКадровыхДокументах"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЗначениеПоказателя",
		"Заголовок",
		РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("РеквизитТарифВКадровыхДокументах"));
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "Сотрудник");
	КонецЕсли; 
	
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
	
	ПрочитатьВремяРегистрации();
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ИзменениеКвалификационногоРазряда", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыНачисления" И Источник = ЭтаФорма Тогда
		ЗаполнитьНачисленияИзВРеменногоХранилища(Параметр.АдресВХранилище);
	КонецЕсли;
	
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
Процедура СотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИзмененияПриИзменении(Элемент)
	
	ДатаИзмененияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РазрядКатегорияПриИзменении(Элемент)
	
	РазрядКатегорияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателяПриИзменении(Элемент)
	
	ЗначениеПоказателяПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачисленияУтвержденыПриИзменении(Элемент)
	
	НачисленияУтвержденыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура НачисленияУтвержденыПриИзмененииНаСервере()
	
	ЗарплатаКадрыРасширенный.УстановитьПредупреждающуюНадписьВМногофункциональныхДокументах(ЭтаФорма, "НачисленияУтверждены");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьДокументыВведенныеПозже(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.ДокументыВведенныеПозже);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьРанееВведенныеДокументы(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.РанееВведенныеДокументы);
	
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

&НаКлиенте
Процедура ИзменитьФОТ(Команда)
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("АдресВХранилище", АдресВХранилищеНачисленийИУдержаний());
		ПараметрыОткрытия.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		
		ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуРедактированияСоставаНачисленийИУдержаний(ПараметрыОткрытия, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	УстановитьДоступностьРегистрацииНачислений();
	
	ИспользуетсяРасчетЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная");
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПрочитатьВремяРегистрации();
	
	ЗарплатаКадрыРасширенный.МногофункциональныеДокументыДобавитьЭлементыФормы(
		ЭтаФорма, НСтр("ru='Изменение разряда утверждено'"), , "НачисленияУтверждены");
		
	ЗарплатаКадрыРасширенный.ОформлениеНесколькихДокументовНаОднуДатуДополнитьФорму(ЭтотОбъект);	
		
	ЗарплатаКадрыРасширенный.УстановитьПредупреждающуюНадписьВМногофункциональныхДокументах(ЭтаФорма, "НачисленияУтверждены");
	
	Если ИспользуетсяРасчетЗарплаты И Не ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений И Объект.НачисленияУтверждены Тогда 
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ПрочитатьКадровыеДанныеСотрудника();
	ПрочитатьТарифнуюСетку();
	
	УстановитьВидимостьРасчетныхПолей();
	
	Если ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений Тогда 
		РассчитатьФОТНаФорме(ЭтаФорма);
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейПересчетаТарифнойСтавки(ЭтаФорма, ОписаниеТаблицыНачислений());
	ЗарплатаКадрыРасширенный.УстановитьРазмерностьСовокупнойТарифнойСтавки(ЭтаФорма);
	ЗарплатаКадрыРасширенный.УстановитьКомментарийКРазмеруСовокупнойТарифнойСтавки(ЭтаФорма, Объект.ВидТарифнойСтавки);
	
	УстановитьОтображениеНадписей();
	
	РазрядыКатегорииДолжностей.УстановитьСвязиПараметровВыбораРазрядаКадровогоПриказа(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Объект.Показатель) Тогда 
		ПоказательИнфо = ЗарплатаКадрыРасширенный.СведенияОПоказателеРасчетаЗарплаты(Объект.Показатель);
		ФорматРедактирования = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЧДЦ=%1", ПоказательИнфо["Точность"]);
	    ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗначениеПоказателя", "ФорматРедактирования", ФорматРедактирования);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	ПрочитатьВремяРегистрации();
	ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей();
	УстановитьТекущиеДанныеСотрудника();
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура ДатаИзмененияПриИзмененииНаСервере()

	ПрочитатьВремяРегистрации();
	УстановитьТекущиеДанныеСотрудника();
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура РазрядКатегорияПриИзмененииНаСервере()
	
	ЗаполнитьЗначениеПоказателя();
	РассчитатьФОТПоДокументу();
	
КонецПроцедуры

&НаСервере
Процедура ЗначениеПоказателяПриИзмененииНаСервере()
	
	РассчитатьФОТПоДокументу();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущиеДанныеСотрудника()
	
	ЗаполнитьНачисленияСотрудника();
	
	ПрочитатьКадровыеДанныеСотрудника();
	ПрочитатьТарифнуюСетку();
	ЗаполнитьРазрядСотрудника();
	ЗаполнитьЗначениеПоказателя();
	РассчитатьФОТНаФорме(ЭтаФорма);
	
	ЗарплатаКадрыРасширенный.УстановитьТекущееЗначениеСовокупнойТарифнойСтавки(ЭтаФорма, Объект.Сотрудник, ВремяРегистрации);
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейПересчетаТарифнойСтавки(ЭтаФорма, ОписаниеТаблицыНачислений(), ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьКадровыеДанныеСотрудника()
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Объект.Сотрудник, "КоличествоСтавок", Объект.ДатаИзменения);
	Если КадровыеДанные.Количество() > 0 Тогда
		КоличествоСтавок = КадровыеДанные[0].КоличествоСтавок;
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачисленияСотрудника()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Объект.Начисления.Очистить();
	
	Если Не ЗначениеЗаполнено(Объект.Сотрудник) Или Не ЗначениеЗаполнено(Объект.ДатаИзменения) Тогда 
		Возврат;
	КонецЕсли;
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	НоваяСтрока = СотрудникиДаты.Добавить();
	НоваяСтрока.Сотрудник = Объект.Сотрудник;
	НоваяСтрока.Период = ВремяРегистрации;
	
	ДанныеНачислений = РасчетЗарплатыРасширенный.ДействующиеПлановыеНачисления(СотрудникиДаты, Объект.Ссылка);
	Объект.Начисления.Загрузить(ДанныеНачислений.Начисления);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьТарифнуюСетку()
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		
		ДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Объект.Сотрудник, "Должность,ДолжностьПоШтатномуРасписанию", ВремяРегистрации, , Ложь);
		Если ДанныеСотрудников.Количество() > 0 Тогда
			
			Должность = ДанныеСотрудников[0].Должность;
			ДолжностьПоШтатномуРасписанию = ДанныеСотрудников[0].ДолжностьПоШтатномуРасписанию;
			
			КадровыйУчетФормыРасширенный.УстановитьДанныеДолжностиВФорме(
				ЭтаФорма, ВремяРегистрации, Должность, ДолжностьПоШтатномуРасписанию);
			
			РазрядыКатегорииДолжностей.ПрочитатьДанныеТарифныхСетокДолжностиВФорму(ЭтаФорма, Должность, ДолжностьПоШтатномуРасписанию, ВремяРегистрации);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРазрядСотрудника()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Объект.РазрядКатегория = Неопределено;
	
	Если Не ЗначениеЗаполнено(Объект.Сотрудник) Или Не ЗначениеЗаполнено(Объект.ДатаИзменения) Тогда 
		Возврат;
	КонецЕсли;
	
	СписокСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник);
	
	Отбор = Новый Массив;
	Отбор.Добавить(Новый Структура("ЛевоеЗначение,ВидСравнения,ПравоеЗначение","Регистратор", "<>", Объект.Ссылка));
	
	ПоляОтбора = Новый Структура("РазрядыКатегорииСотрудников", Отбор);
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Ложь, СписокСотрудников, "РазрядКатегория", ВремяРегистрации, ПоляОтбора, Ложь);  
	
	Если КадровыеДанные.Количество() > 0 Тогда 
		Объект.РазрядКатегория = КадровыеДанные[0].РазрядКатегория;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначениеПоказателя()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Объект.Показатель = Неопределено;
	Объект.ЗначениеПоказателя = 0;
	
	Если Не ЗначениеЗаполнено(Объект.Сотрудник) Или Не ЗначениеЗаполнено(Объект.ДатаИзменения) Тогда 
		Возврат;
	КонецЕсли;
	
	СписокСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник);
	
	Отбор = Новый Массив;
	Отбор.Добавить(Новый Структура("ЛевоеЗначение,ВидСравнения,ПравоеЗначение","Регистратор", "<>", Объект.Ссылка));
	
	ПоляОтбора = Новый Структура("КадроваяИсторияСотрудников", Отбор);
	
	ТарифнаяСетка = Неопределено;
	ТарифнаяСеткаНадбавки = Неопределено;
	
	КадровыеДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Объект.Сотрудник, "ТарифнаяСетка,ТарифнаяСеткаНадбавки", ВремяРегистрации, ПоляОтбора, Ложь);
	Если КадровыеДанныеСотрудника.Количество() > 0  Тогда
		ТарифнаяСетка = КадровыеДанныеСотрудника[0].ТарифнаяСетка;
		ТарифнаяСеткаНадбавки = КадровыеДанныеСотрудника[0].ТарифнаяСеткаНадбавки;
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении") Тогда 
		
		Если Не ЗначениеЗаполнено(ТарифнаяСеткаНадбавки) Тогда 
			Возврат;
		КонецЕсли;	
		
		Объект.Показатель = РазрядыКатегорииДолжностей.ПоказательТарифнойСеткиСотрудника( , ТарифнаяСеткаНадбавки, Объект.Начисления);	
		ТарифнаяСетка = ТарифнаяСеткаНадбавки;
		
	Иначе 
		
		Если Не ЗначениеЗаполнено(ТарифнаяСетка) Тогда 
			Возврат;
		КонецЕсли;	
		
		Объект.Показатель = РазрядыКатегорииДолжностей.ПоказательТарифнойСеткиСотрудника(ТарифнаяСетка, , Объект.Начисления);
		
	КонецЕсли;
	
	КоэффициентПересчета = 1;
	Если ЗначениеЗаполнено(Объект.Показатель) Тогда 
		ПоказательИнфо = ЗарплатаКадрыРасширенный.СведенияОПоказателеРасчетаЗарплаты(Объект.Показатель);
		Если ПоказательИнфо.ВидТарифнойСтавки = Перечисления.ВидыТарифныхСтавок.МесячнаяТарифнаяСтавка Тогда
			КоэффициентПересчета = КоличествоСтавок;
		КонецЕсли; 
		ФорматРедактирования = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЧДЦ=%1", ПоказательИнфо["Точность"]);
	    ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗначениеПоказателя", "ФорматРедактирования", ФорматРедактирования);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Период",  Объект.ДатаИзменения);
	Запрос.УстановитьПараметр("ТарифнаяСетка", ТарифнаяСетка);
	Запрос.УстановитьПараметр("РазрядКатегория", Объект.РазрядКатегория);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	&Период КАК Период,
	               |	&ТарифнаяСетка КАК ТарифнаяСетка,
	               |	&РазрядКатегория КАК РазрядКатегория
	               |ПОМЕСТИТЬ ВТДанныеДокумента";
	
	Запрос.Выполнить();
	
	ПараметрыПостроения = РазрядыКатегорииДолжностей.ПараметрыПостроенияВТЗначенияПоказателейТарифныхСеток("ВТДанныеДокумента");
	
	РазрядыКатегорииДолжностей.СоздатьВТЗначенияПоказателейТарифныхСеток(Запрос.МенеджерВременныхТаблиц, Ложь, ПараметрыПостроения);
	
	Запрос.УстановитьПараметр("КоэффициентПересчета", КоэффициентПересчета);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗначенияПоказателейТарифныхСеток.ЗначениеПоказателя * &КоэффициентПересчета КАК ЗначениеПоказателя
	               |ИЗ
	               |	ВТЗначенияПоказателейТарифныхСеток КАК ЗначенияПоказателейТарифныхСеток";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда 
		ЗаполнитьЗначенияСвойств(Объект, Выборка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыНачислений() 
	
	Возврат Новый Структура("ПутьКДанным", "Объект.Начисления");

КонецФункции

&НаСервере
Процедура РассчитатьФОТПоДокументу()

	Если Не ЗначениеЗаполнено(Объект.Сотрудник) 
		Или Не ЗначениеЗаполнено(Объект.ДатаИзменения) 
		Или Не ЗначениеЗаполнено(Объект.Показатель) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ГоловнаяОрганизация = ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(Объект.Организация);
	ТаблицаНачислений = ПлановыеНачисленияСотрудников.ТаблицаНачисленийДляРасчетаВторичныхДанных();
	ТаблицаПоказателей = ПлановыеНачисленияСотрудников.ТаблицаИзвестныеПоказатели();
	РассчитываемыеОбъекты = Новый Соответствие;

	МассивНачислений = ОбщегоНазначения.ВыгрузитьКолонку(Объект.Начисления, "Начисление", Истина);
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(МассивНачислений, ПланыВидовРасчета.Начисления.ПустаяСсылка());
	
	ИнформацияОВидахРасчета = ЗарплатаКадрыРасширенный.ИнформацияОВидахРасчета(МассивНачислений);
	
	ОснованияНачислений = Новый Массив;
	
	// Все начисления сотрудника
	Для Каждого СтрокаНачисления Из Объект.Начисления Цикл
		
		ВидРасчетаИнфо = ИнформацияОВидахРасчета[СтрокаНачисления.Начисление];
		Если ВидРасчетаИнфо = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		ДанныеНачисления = ТаблицаНачислений.Добавить();
		ДанныеНачисления.Сотрудник = Объект.Сотрудник;
		ДанныеНачисления.ГоловнаяОрганизация = ГоловнаяОрганизация;
		ДанныеНачисления.Период = ВремяРегистрации;
		ДанныеНачисления.Начисление = СтрокаНачисления.Начисление;
		ДанныеНачисления.ДокументОснование = СтрокаНачисления.ДокументОснование;
		ДанныеНачисления.Размер = ?(ВидРасчетаИнфо.Рассчитывается, 0, СтрокаНачисления.Размер);
		
		Для Каждого СведенияОПоказателе Из ВидРасчетаИнфо.Показатели Цикл 
			Если СведенияОПоказателе.Показатель = Объект.Показатель Тогда
				Если ОснованияНачислений.Найти(СтрокаНачисления.ДокументОснование) = Неопределено Тогда 
					ОснованияНачислений.Добавить(СтрокаНачисления.ДокументОснование);
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	
	КонецЦикла;
	
	Если ОснованияНачислений.Количество() = 0 Тогда 
		ДанныеПоказателя = ТаблицаПоказателей.Добавить();
		ДанныеПоказателя.Сотрудник = Объект.Сотрудник;
		ДанныеПоказателя.ГоловнаяОрганизация = ГоловнаяОрганизация;
		ДанныеПоказателя.Период = ВремяРегистрации;

		ДанныеПоказателя.Показатель = Объект.Показатель;
		ДанныеПоказателя.ДокументОснование = Неопределено;
		ДанныеПоказателя.Значение = Объект.ЗначениеПоказателя;
	Иначе 
		Для Каждого ДокументОснование Из ОснованияНачислений Цикл 
			ДанныеПоказателя = ТаблицаПоказателей.Добавить();
			ДанныеПоказателя.Сотрудник = Объект.Сотрудник;
			ДанныеПоказателя.ГоловнаяОрганизация = ГоловнаяОрганизация;
			ДанныеПоказателя.Период = ВремяРегистрации;
			ДанныеПоказателя.Показатель = Объект.Показатель;
			ДанныеПоказателя.ДокументОснование = ДокументОснование;
			ДанныеПоказателя.Значение = Объект.ЗначениеПоказателя;
		КонецЦикла;
	КонецЕсли;
	
	РассчитанныеДанные = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(ТаблицаНачислений, ТаблицаПоказателей);
		
	Объект.Начисления.Очистить();
	
	Для Каждого ОписаниеНачисления Из ТаблицаНачислений Цикл
		
		НовоеНачисление = Объект.Начисления.Добавить();
		НовоеНачисление.Начисление = ОписаниеНачисления.Начисление;
		НовоеНачисление.ДокументОснование = ОписаниеНачисления.ДокументОснование;
		НовоеНачисление.Размер = ОписаниеНачисления.ВкладВФОТ;
		
	КонецЦикла;
	
	Если РассчитанныеДанные.ТарифныеСтавки.Количество() > 0 Тогда 
		Объект.СовокупнаяТарифнаяСтавка = РассчитанныеДанные.ТарифныеСтавки[0].СовокупнаяТарифнаяСтавка;
		Объект.ВидТарифнойСтавки = РассчитанныеДанные.ТарифныеСтавки[0].ВидТарифнойСтавки;
	Иначе 
		Объект.СовокупнаяТарифнаяСтавка = Неопределено;
		Объект.ВидТарифнойСтавки = Неопределено;
	КонецЕсли;

	
	РассчитатьФОТНаФорме(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьФОТНаФорме(Форма)
	
	Форма.ФОТ = Форма.Объект.Начисления.Итог("Размер");
	
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеНачисленийИУдержаний()
	
	ПараметрыОткрытия = ЗарплатаКадрыРасширенныйКлиентСервер.ПараметрыРедактированияСоставаНачисленийИУдержаний();
	
	ПараметрыОткрытия.ВладелецНачисленийИУдержаний = Объект.Сотрудник;
	ПараметрыОткрытия.ДатаРедактирования = ВремяРегистрации;
	ПараметрыОткрытия.Организация = Объект.Организация;
	ПараметрыОткрытия.РежимРаботы = 3;
	ПараметрыОткрытия.ДополнитьНедостающиеЗначенияПоказателей = Истина;
	
	ДополнитьСтруктуруНачислениямиИПоказателями(ПараметрыОткрытия);
	
	Возврат ПоместитьВоВременноеХранилище(ПараметрыОткрытия, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ДополнитьСтруктуруНачислениямиИПоказателями(ПараметрыОткрытия)
	
	МассивНачислений = Новый Массив;
	МассивПоказателей = Новый Массив;
	
	ИдентификаторСтрокиВидаРасчета = 1;
	Для каждого СтрокаНачислений Из Объект.Начисления Цикл
		
		СтруктураНачисления = Новый Структура("Начисление,ДокументОснование,ИдентификаторСтрокиВидаРасчета,Размер");
		ЗаполнитьЗначенияСвойств(СтруктураНачисления, СтрокаНачислений);
		СтруктураНачисления.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета;
		МассивНачислений.Добавить(СтруктураНачисления);
		
		ОписаниеНачисления = ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьИнформациюОВидеРасчета(СтруктураНачисления.Начисление);
		Для каждого ОписаниеПоказателя Из ОписаниеНачисления.Показатели Цикл
			Если ОписаниеПоказателя.ЗапрашиватьПриВводе Тогда
				
				Если ОписаниеПоказателя.Показатель = Объект.Показатель Тогда
					СтруктураПоказателя = Новый Структура("Показатель,ИдентификаторСтрокиВидаРасчета,Значение");
					СтруктураПоказателя.Показатель = ОписаниеПоказателя.Показатель;
					СтруктураПоказателя.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета;
					СтруктураПоказателя.Значение = Объект.ЗначениеПоказателя;
					МассивПоказателей.Добавить(СтруктураПоказателя);
				КонецЕсли; 
				
			КонецЕсли; 
		КонецЦикла;
		
		ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета + 1;
		
	КонецЦикла;
	
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.Используется = Истина;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.Таблица = МассивНачислений;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ИзменятьСоставВидовРасчета = Ложь;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ИзменятьЗначенияПоказателей = Ложь;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.НомерТаблицы = 1;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ПоказатьФОТ = Истина;
	
	ПараметрыОткрытия.Показатели = МассивПоказателей;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачисленияИзВРеменногоХранилища(АдресВХранилище);
	
	ДанныеИзХранилища = ПолучитьИзВременногоХранилища(АдресВХранилище);
	
	Если ДанныеИзХранилища = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Сотрудник = ДанныеИзХранилища.ВладелецНачисленийИУдержаний;
	
	Для Каждого НачислениеСотрудника Из ДанныеИзХранилища.Начисления Цикл
		
		СтрокиНачисления = Объект.Начисления.НайтиСтроки(Новый Структура("Начисление", НачислениеСотрудника.Начисление));
		Если СтрокиНачисления.Количество() > 0 Тогда
			СтрокиНачисления[0].Размер = НачислениеСотрудника.Размер;
		КонецЕсли;		
		
	КонецЦикла;
	
	РассчитатьФОТНаФорме(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьВремяРегистрации()
	
	ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудникаДокумента(Объект.Ссылка, Объект.Сотрудник, Объект.ДатаИзменения);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеНадписей()
	
	МассивСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник);
	ЗарплатаКадрыРасширенный.УстановитьТекстНадписиОДокументахВведенныхНаДату(ЭтотОбъект, ВремяРегистрации, 
								МассивСотрудников, Объект.Ссылка, ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений);
	
КонецПроцедуры

#Область ПроцедурыИФункцииМеханизмаМногофункциональныхДокументов

&НаСервере
Процедура УстановитьВидимостьРасчетныхПолей()
	
	ИменаЭлементов = Новый Массив;
	ИменаЭлементов.Добавить("ГруппаФОТ");
	ИменаЭлементов.Добавить("ЗначениеПоказателя");
	ИменаЭлементов.Добавить("СовокупнаяТарифнаяСтавкаСтраница");
	
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейМногофункциональныхДокументов(ЭтаФорма, ИменаЭлементов);
	
	Если ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений Тогда 
		ЗарплатаКадрыРасширенный.УстановитьОтображениеГруппыФормы(Элементы, "ГруппаФОТ", "ТолькоПросмотр", Истина);
		ЗарплатаКадрыРасширенный.УстановитьОтображениеГруппыФормы(Элементы, "СовокупнаяТарифнаяСтавкаСтраница", "ТолькоПросмотр", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьРегистрацииНачислений()
	
	ПраваНаДокумент = ЗарплатаКадрыРасширенный.ПраваНаМногофункциональныйДокумент(Объект);
	РегистрацияНачисленийДоступна = ПраваНаДокумент.ПолныеПраваПоРолям;
	ОграниченияНаУровнеЗаписей = Новый ФиксированнаяСтруктура(ПраваНаДокумент.ОграниченияНаУровнеЗаписей);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей()
	
	БылиОграничения = ОграниченияНаУровнеЗаписей;
	УстановитьДоступностьРегистрацииНачислений();
	
	Если БылиОграничения.ЧтениеБезОграничений <> ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений
		Или БылиОграничения.ИзменениеБезОграничений <> ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений
		Или БылиОграничения.ИзменениеКадровыхДанных <> ОграниченияНаУровнеЗаписей.ИзменениеКадровыхДанных Тогда 
		
		Объект.ОтменаДоплатыУтверждена = ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений;
		
		УстановитьВидимостьРасчетныхПолей();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей();
	ЗаполнитьДанныеФормыПоОрганизации();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли; 
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));	
	
КонецПроцедуры

#КонецОбласти
