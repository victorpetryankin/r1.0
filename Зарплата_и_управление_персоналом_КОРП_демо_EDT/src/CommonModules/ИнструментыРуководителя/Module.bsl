
#Область УправлениеДоступом

Процедура ЗаполнитьПоставляемыеПрофилиГруппДоступа(ОписанияПрофилей, ПараметрыОбновления) Экспорт 

	ОписаниеПрофиля = ОписаниеПрофиляРуководительПодразделения();
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

// Возвращает описание профиля "Руководитель подразделения".
//
Функция ОписаниеПрофиляРуководительПодразделения()
	
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = ИдентификаторПрофиляРуководительПодразделения();
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Руководитель подразделения'");
	
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляОбязательныеРоли(ОписаниеПрофиля);

	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ДобавлениеИзменениеДанныхДляНачисленияЗарплатыПриложения", "ЗарплатаКадрыПриложения.ВнешниеДанные");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ДобавлениеИзменениеДанныхДляРасчетаЗарплаты");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеДанныхСотрудников");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеДанныхСотрудниковРасширенная");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеДанныхФизическихЛицЗарплатаКадры");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеДанныхФизическихЛицЗарплатаКадрыРасширенная");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеРабочегоВремени");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеСостоянийСотрудников");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеШтатногоРасписания");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ИспользованиеОсновногоРабочегоСтола");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ИнтерфейсРабочегоСтолаРуководительПодразделения");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеБезПросмотраНачисленияУдержанияПоказатели");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеДанныхОбОбразованииФизическихЛиц");
	
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ДобавлениеИзменениеЗаявокНаПодборПерсонала", "ЗарплатаКадрыКорпоративнаяПодсистемы.ПодборПерсонала");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеПрофилейДолжности", "ЗарплатаКадрыКорпоративнаяПодсистемы.ПодборПерсонала");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеВакансий", "ЗарплатаКадрыКорпоративнаяПодсистемы.ПодборПерсонала");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеДанныхКандидатов", "ЗарплатаКадрыКорпоративнаяПодсистемы.ПодборПерсонала");
	
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеМероприятийАдаптацииУвольнения", "ЗарплатаКадрыКорпоративнаяПодсистемы.АдаптацияУвольнение");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеРешенийПоКадровымИзменениям", "ЗарплатаКадрыКорпоративнаяПодсистемы.АдаптацияУвольнение");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "КонтрольИсполненияМероприятийАдаптацииУвольнения", "ЗарплатаКадрыКорпоративнаяПодсистемы.АдаптацияУвольнение");
	
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ДобавлениеИзменениеЗаписейРабочегоКалендаряСотрудников", "ЗарплатаКадрыКорпоративнаяПодсистемы.РабочийКалендарь");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеЗабронированныхПомещений", "ЗарплатаКадрыКорпоративнаяПодсистемы.БронированиеПомещений");
	
	// Характеристики персонала.
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеДействийСотрудников", "ЗарплатаКадрыКорпоративнаяПодсистемы.ХарактеристикиПерсонала");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеКомпетенцийПерсонала", "ЗарплатаКадрыКорпоративнаяПодсистемы.ХарактеристикиПерсонала");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеХарактеристикПерсонала", "ЗарплатаКадрыКорпоративнаяПодсистемы.ХарактеристикиПерсонала");
	
	// Электронное интервью.
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеДанныхЭлектронногоИнтервью", "ЗарплатаКадрыКорпоративнаяПодсистемы.ЭлектронноеИнтервью");
	
	// Обучение.
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ПодсистемаОбучениеИРазвитие", "ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ДобавлениеИзменениеЗаявокНаОбучениеРазвитие", "ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие");
	ЗарплатаКадрыРасширенный.ДобавитьВОписаниеПрофиляРоль(ОписаниеПрофиля, "ЧтениеОбученияРазвития", "ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие");
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ПодразделенияОрганизаций");
	ОписаниеПрофиля.ВидыДоступа.Добавить("ГруппыФизическихЛиц");
	// ОрганизационнаяСтруктура
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
		Модуль.ДополнитьОписаниеПрофиля(ОписаниеПрофиля);
	КонецЕсли;
	// Конец ОрганизационнаяСтруктура
	
	Возврат ОписаниеПрофиля;
	
КонецФункции

Функция ИдентификаторПрофиляРуководительПодразделения() Экспорт
	Возврат "a7ba173f-e4a9-11e2-8c22-e0cb4ed5f6a2";
КонецФункции

#КонецОбласти