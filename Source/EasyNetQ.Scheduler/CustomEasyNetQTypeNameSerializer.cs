﻿using System;
using System.Collections.Concurrent;
using EasyNetQ;

namespace blueC.Service.MQ.Serializer
{
    /// <summary>
    /// This changes the default function of the EasyNetQ Name in serialization to not include the assembly.
    /// Makes it so that types in a shared project will work instead of requiring a shared library with shared namespace and assembly name.
    /// Original: https://github.com/EasyNetQ/EasyNetQ/blob/master/Source/EasyNetQ/TypeNameSerializer.cs
    /// </summary>
    public class CustomEasyNetQTypeNameSerializer : EasyNetQ.ITypeNameSerializer
    {
        private readonly ConcurrentDictionary<string, Type> deserializedTypes = new ConcurrentDictionary<string, Type>();

        public Type DeSerialize(string typeName)
        {
            //Preconditions.CheckNotBlank(typeName, "typeName");

            return deserializedTypes.GetOrAdd(typeName, t =>
            {
                /*var nameParts = t.Split(':');
                if (nameParts.Length != 2)
                {
                    throw new EasyNetQException("type name {0}, is not a valid EasyNetQ type name. Expected Type:Assembly", t);
                }
                var type = Type.GetType(nameParts[0] + ", " + nameParts[1]);*/
                var type = Type.GetType(typeName + ",EasyNetQ");
                if (type == null)
                {
                    throw new EasyNetQException("Cannot find type {0}", t);
                }
                return type;
            });
        }

        private readonly ConcurrentDictionary<Type, string> serializedTypes = new ConcurrentDictionary<Type, string>();

        public string Serialize(Type type)
        {
            //Preconditions.CheckNotNull(type, "type");

            return serializedTypes.GetOrAdd(type, t =>
            {

                var typeName = t.FullName; // + ":" + t.GetTypeInfo().Assembly.GetName().Name;
                if (typeName.Length > 255)
                {
                    throw new EasyNetQException("The serialized name of type '{0}' exceeds the AMQP " +
                                                "maximum short string length of 255 characters.", t.Name);
                }
                return typeName;
            });
        }
    }
}