
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства

	РасчетЗарплатыРасширенныйФормы.ДокументыПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ = Документы.ДоговорАвторскогоЗаказа.ПустаяСсылка() Тогда
		
		Объект.КодВычета = УчетНДФЛ.ВычетВПределахНормативовПоАвторскимВознаграждениям();
		Объект.СпособОплаты = Перечисления.СпособыОплатыПоДоговоруГПХ.ОднократноВКонцеСрока;
		
		// создается новый документ
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный", 
		"Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			КадровыйУчетРасширенный.УстановитьРольДоговорникСотруднику(Объект.Сотрудник);
		КонецЕсли;
		
		ЗаполнитьДанныеФормыПоОрганизации();
		УстановитьФункциональныеОпцииФормы();
						
	КонецЕсли;
	
	СотрудникПрежний = Объект.Сотрудник;
	
	УстановитьПараметрСпискаАктов();
	
	УстановитьВидимостьВводаНаОснованииАкта(ЭтаФорма, Объект.СпособОплаты);
	
	УстановитьДоступностьЗакладкиАктов(ЭтаФорма, Объект.СпособОплаты);
	
	УстановитьВидимостьДатыДвиженийПФР();
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Распределяется = Объект.ОтношениеКЕНВД = Перечисления.ОтношениеКЕНВДЗатратНаЗарплату.ОпределяетсяЕжемесячноПроцентом;
	Если Распределяется Тогда
		Элементы.СтраницыЕНВД.ТекущаяСтраница = Элементы.СтраницаЕНВД;
	Иначе
		Элементы.СтраницыЕНВД.ТекущаяСтраница = Элементы.СтраницаЕНВДПустая;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	УстановитьДоступностьСуммыВычета();
	ОбновитьВычетИнфоНадпись();
	УстановитьДоступностьЭлементаРазмерПлатежа();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВычетИнфоНадпись()

	ВычетПоНормативу = Объект.КодВычета = УчетНДФЛКлиентПовтИсп.ВычетВПределахНормативовПоАвторскимВознаграждениям();
		
	Если ВычетПоНормативу Тогда
		СведенияОВычете = СведенияОВычетах(Объект.ВидАвторскогоДоговора, Объект.Сумма, Объект.Дата);
		НормативЗатрат = СведенияОВычете.НормативЗатрат;
		СуммаВычетаПоНормативу = Формат(СведенияОВычете.СуммаВычета, "ЧДЦ=2; ЧРД=");
		Описание = НСтр("ru = 'Сумма вычета предоставляется в пределах нормативов затрат: %1%,  Сумма вычета: %2 руб.'");
		ВычетПоНормативуИнфоНадпись = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Описание,НормативЗатрат,СуммаВычетаПоНормативу);
	Иначе
		Если Объект.СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот") Тогда
			ВычетИнфоНадпись = НСтр("ru = 'Размер документально подтвержденных расходов, связанных с выполнением работ и принимаемых в качестве налогового вычета указывается в актах выполненных работ.'");
		Иначе
			ВычетИнфоНадпись = НСтр("ru = 'Если при вводе информации о договоре работы уже выполнены и уже известна сумма документально подтвержденных расходов, связанных с выполнением работ и принимаемых в качестве налогового вычета, введите эту сумму.'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СведенияОВычетах(ВидАвторскогоДоговора, Сумма, ДатаСреза)

	СведенияОВычете = Новый Структура("НормативЗатрат,СуммаВычета",0,0);
	
	КодДохода = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидАвторскогоДоговора,"КодДоходаНДФЛ");
	Отбор = Новый Структура("КодДохода", КодДохода);
	ВычетыПоДоходамНДФЛ = РегистрыСведений.ВычетыПоДоходамНДФЛ.СрезПоследних(ДатаСреза, Отбор);
	Если ВычетыПоДоходамНДФЛ.Количество() > 0 Тогда
		НормативЗатрат = ВычетыПоДоходамНДФЛ[0].НормативЗатрат;
		СуммаВычета = ОКР(Сумма * НормативЗатрат / 100, 2);
		СведенияОВычете.НормативЗатрат = НормативЗатрат;
		СведенияОВычете.СуммаВычета = СуммаВычета;
	КонецЕсли;
	
	Возврат СведенияОВычете;

КонецФункции

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	УстановитьФункциональныеОпцииФормы();
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	СтруктураПараметровОповещения = Новый Структура;
	СтруктураПараметровОповещения.Вставить("Проведен", ЭтаФорма.Объект.Проведен);
	СтруктураПараметровОповещения.Вставить("ПомеченНаУдаление", ЭтаФорма.Объект.ПометкаУдаления);
	СтруктураПараметровОповещения.Вставить("Результат", ЭтаФорма.Объект.Ссылка);
	СтруктураПараметровОповещения.Вставить("Ответственный", ЭтаФорма.Объект.Ответственный);
	СтруктураПараметровОповещения.Вставить("ДатаДокумента", ЭтаФорма.Объект.Дата);
	СтруктураПараметровОповещения.Вставить("НомерДокумента", ЭтаФорма.Объект.Номер);
	СтруктураПараметровОповещения.Вставить("Сотрудник", ЭтаФорма.Объект.Сотрудник);
	Оповестить("ДокументДоговорАвторскогоЗаказаПослеЗаписи", СтруктураПараметровОповещения, ЭтаФорма);
	Оповестить("Запись_ДоговорАвторскогоЗаказа", ПараметрыЗаписи, Объект.Ссылка);
	
	УстановитьДоступностьЗакладкиАктов(ЭтаФорма, Объект.СпособОплаты);
	
	УстановитьПараметрСпискаАктов();

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбработатьИзменениеОрганизацииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ОбработатьИзменениеДатыДокументаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КодВычетаПриИзменении(Элемент)
	
	УстановитьДоступностьСуммыВычета();
	ОбновитьВычетИнфоНадпись();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидАвторскогоДоговораПриИзменении(Элемент)
	
	УстановитьДоступностьСуммыВычета();
	ОбновитьВычетИнфоНадпись();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОплатыПриИзменении(Элемент)
	
	Если Объект.СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот") И Объект.СуммаВычета <> 0 Тогда
		Объект.СуммаВычета = 0;
	КонецЕсли;
	УстановитьДоступностьСуммыВычета();
	ОбновитьВычетИнфоНадпись();
	
	УстановитьВидимостьВводаНаОснованииАкта(ЭтаФорма, Объект.СпособОплаты);
	УстановитьДоступностьЗакладкиАктов(ЭтаФорма, Объект.СпособОплаты);
	УстановитьДоступностьЭлементаРазмерПлатежа();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	Если СотрудникПрежний <> Объект.Сотрудник Тогда
		НовыеНастройкиБухучета = "";
		ОбработатьИзменениеСотрудникаНаСервереБезКонтекста(Объект.Сотрудник, НовыеНастройкиБухучета);
		ЗаполнитьЗначенияСвойств(Объект, НовыеНастройкиБухучета);
		ОбработатьИзменениеОтношениеКЕНВД();
		СотрудникПрежний = Объект.Сотрудник;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьИзменениеСотрудникаНаСервереБезКонтекста(Сотрудник, НастройкиБухучета)

	КадровыйУчетРасширенный.УстановитьРольДоговорникСотруднику(Сотрудник);
	
	НастройкиБухучета = Новый Структура("Подразделение, Территория, СтатьяФинансирования, СтатьяРасходов, СпособОтраженияЗарплатыВБухучете, ОтношениеКЕНВД");
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина,Сотрудник,"ТекущееПодразделение, ТекущаяТерритория");
	Если КадровыеДанные.Количество()>0 Тогда
		НастройкиБухучета.Подразделение = КадровыеДанные[0].ТекущееПодразделение;
		НастройкиБухучета.Территория    = КадровыеДанные[0].ТекущаяТерритория;
	КонецЕсли;
	БухучетСотрудника = ОтражениеЗарплатыВБухучетеРасширенный.НастройкаБухучетаЗарплатыСотрудника(Сотрудник, ТекущаяДатаСеанса());
	ЗаполнитьЗначенияСвойств(НастройкиБухучета, БухучетСотрудника);

КонецПроцедуры

&НаКлиенте
Процедура ОтношениеКЕНВДПриИзменении(Элемент)
	
	ОбработатьИзменениеОтношениеКЕНВД();
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеОтношениеКЕНВД()

	Если Не ПолучитьФункциональнуюОпциюФормы("ПлательщикЕНВДЗарплатаКадры") Тогда
		Возврат;
	КонецЕсли;
	
	Распределяется = Объект.ОтношениеКЕНВД = ПредопределенноеЗначение("Перечисление.ОтношениеКЕНВДЗатратНаЗарплату.ОпределяетсяЕжемесячноПроцентом");
	Если Объект.СуммаЕНВД <> 0 И Не Распределяется Тогда
		Объект.СуммаЕНВД = 0;
	КонецЕсли;
	Если Распределяется Тогда
		Элементы.СтраницыЕНВД.ТекущаяСтраница = Элементы.СтраницаЕНВД;
	Иначе
		Элементы.СтраницыЕНВД.ТекущаяСтраница = Элементы.СтраницаЕНВДПустая;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СуммаЕНВДПриИзменении(Элемент)
	
	ПроверитьСуммуЕНВД();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	
	ПроверитьСуммуЕНВД();
	ОбновитьВычетИнфоНадпись();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСуммуЕНВД()

	Если Объект.СуммаЕНВД > Объект.Сумма Тогда
		ТекстПредупреждения = НСтр("ru = 'Сумма ЕНВД не может превышать общей суммы вознаграждения по договору.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Объект.СуммаЕНВД = 0;
	КонецЕсли;

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

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура СоздатьАкт(Команда)
	
	Если Модифицированность Тогда
		Записать();                  	
	КонецЕсли;	
		
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Основание", Объект.Ссылка);
	
	ОткрытьФорму("Документ.АктПриемкиВыполненныхРаботОказанныхУслуг.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура УстановитьДоступностьСуммыВычета()

	ВычетПоНормативу = Объект.КодВычета = УчетНДФЛКлиентПовтИсп.ВычетВПределахНормативовПоАвторскимВознаграждениям();
	Если ВычетПоНормативу Тогда
		Объект.СуммаВычета = 0;
		Элементы.СтраницыВычеты.ТекущаяСтраница = Элементы.СтраницаВычетПоНормативу;
		Элементы.СтраницыСуммаВычета.ТекущаяСтраница = Элементы.СтраницаСуммаВычетаПустая;
	Иначе
		Элементы.СтраницыВычеты.ТекущаяСтраница = Элементы.СтраницаВычетСуммой;
		Если Объект.СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот") Тогда
			Элементы.СтраницыСуммаВычета.ТекущаяСтраница = Элементы.СтраницаСуммаВычетаПустая;
		Иначе
			Элементы.СтраницыСуммаВычета.ТекущаяСтраница = Элементы.СтраницаСуммаВычета;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьВводаНаОснованииАкта(Форма, СпособОплаты)

	ЭлементыФормы = Форма.КоманднаяПанель.ПодчиненныеЭлементы.ФормаСоздатьНаОсновании.ПодчиненныеЭлементы;
	ЭлементыФормы.ФормаДокументАктПриемкиВыполненныхРаботОказанныхУслугСоздатьНаОсновании.Доступность = 
	СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЗакладкиАктов(Форма, СпособОплаты)
	
	АктыДоступны = ЗначениеЗаполнено(Форма.Объект.Ссылка) И СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот"); 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГруппаАкты",
		"Доступность",
		АктыДоступны); 
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеОрганизацииНаСервере()

	ЗаполнитьДанныеФормыПоОрганизации();
	УстановитьФункциональныеОпцииФормы();

КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеДатыДокументаНаСервере()

	УстановитьФункциональныеОпцииФормы();

КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	ПараметрыФО = Новый Структура("Организация, Период", Объект.Организация, НачалоДня(Объект.Дата));
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
	РасчетЗарплатыРасширенный.ПриОпределенииПараметровФлажкаНеОблагаетсяНДФЛ(Элементы.Найти("НеОблагаетсяНДФЛ"));
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

&НаКлиенте
Процедура УстановитьДоступностьЭлементаРазмерПлатежа()
	
	Элементы.РазмерПлатежа.Доступность = Объект.СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыПоДоговоруГПХ.ВКонцеСрокаСАвансовымиПлатежами");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрСпискаАктов()
	
	Акты.Параметры.УстановитьЗначениеПараметра("Договор", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДатыДвиженийПФР()
	
	Если ЗначениеЗаполнено(Объект.ДатаНачалаПФР) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"НачалоДвиженийПФРКартинкаРасширеннаяПодсказка",
			"Заголовок",
			СтрШаблон("Дата начала движений ПФР - %1", ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеМесяца(Объект.ДатаНачалаПФР)));
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НачалоДвиженийПФРГруппа",
		"Видимость",
		ЗначениеЗаполнено(Объект.ДатаНачалаПФР));
	
КонецПроцедуры

#КонецОбласти
