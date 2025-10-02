using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.Common
{
    public delegate void NormalHandler();

    public delegate void NormalHandler<T>(T para);
}
