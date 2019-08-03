
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОтменитьНабор(ПараметрКоманды, НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса()));
	ОповеститьОбИзменении(Тип("СправочникСсылка.Вакансии"));
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.СостоянияВакансий"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтменитьНабор(Вакансии, ДатаОтмены)
	Справочники.Вакансии.ОтменитьНабор(Вакансии, ДатаОтмены);
КонецПроцедуры

#КонецОбласти
