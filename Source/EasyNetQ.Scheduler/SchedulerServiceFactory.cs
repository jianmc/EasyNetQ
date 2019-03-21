using System;
using System.Configuration;

namespace EasyNetQ.Scheduler
{
    public static class SchedulerServiceFactory
    {
        public static ISchedulerService CreateScheduler()
        {
            var bus = RabbitHutch.CreateBus(ConfigurationManager.ConnectionStrings["rabbit"]?.ConnectionString, r =>
                r.Register<EasyNetQ.ITypeNameSerializer, blueC.Service.MQ.Serializer.CustomEasyNetQTypeNameSerializer>());

            return new SchedulerService(
                bus, 
                new ScheduleRepository(ScheduleRepositoryConfiguration.FromConfigFile(), () => DateTime.UtcNow),
                SchedulerServiceConfiguration.FromConfigFile());
        }
    }
}
