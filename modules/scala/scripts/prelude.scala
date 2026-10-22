object prelude {
  export cats.syntax.all.*
  export cats.effect.IO
  export cats.effect.std.{Console, Env}
  export cats.effect.syntax.all.*
  export cats.effect.unsafe.implicits.global

  export cps.{
    async, asyncStream, reflect, reify, reifed,
    AsyncShift, AsyncShiftLowPriority0, AsyncShiftLowPriority1,
    AsyncShiftLowPriority2, AsyncShiftLowPriority3,
    CpsAsyncEffectMonad, CpsAsyncEffectMonadInstanceContext,
    CpsAsyncMonad, CpsAsyncMonadInstanceContext,
    CpsConcurrentContextMonad, CpsConcurrentEffectMonad,
    CpsConcurrentEffectMonadInstanceContext, CpsConcurrentMonad,
    CpsConcurrentMonadContext, CpsConcurrentMonadInstanceContext,
    CpsContextMonad, CpsDirect, CpsEffectMonad, CpsMonad, CpsMonadContext,
    CpsMonadContextInclusion, CpsMonadContextProvider, CpsMonadConversion,
    CpsMonadInstanceContext, CpsMonadInstanceContextBody, CpsPreprocessor,
    CpsPureMonadInstanceContext, CpsPureMonadInstanceContextBody,
    CpsRuntimeAsyncAwait, CpsRuntimeAwait, CpsRuntimeAwaitProvider,
    CpsSchedulingMonad, CpsThrowMonad, CpsThrowMonadContext,
    CpsThrowMonadInstanceContext, CpsThrowMonadInstanceContextBody,
    CpsThrowSupport, CpsTryContextMonad, CpsTryEffectMonad, CpsTryMonad,
    CpsTryMonadContext, CpsTryMonadInstanceContext,
    CpsTryMonadInstanceContextBody, CpsTrySupport
  }

  extension [F[_], T, G[_]](inline value: F[T])(
      using cps.CpsMonadContext[G], cps.CpsMonadConversion[F, G]
  ) {
    transparent inline def await: T = cps.await(value)
  }

  @scala.annotation.experimental
  transparent inline def asynchronized[F[_], T](inline value: cps.CpsDirect[F] ?=> T)(
      using cps.CpsDirect[F]
  ): F[T] = cps.asynchronized(value)

  export cps.monads.catsEffect.{
    asyncScope, reifyScope, useOn, using,
    catsAsync, catsConcurrent, catsIO, catsMonadCancel, catsMonadPure,
    catsMonadThrow, ioToFutureConversion, resourceConversion,
    AsyncScopeInferArg, CatsAsync, CatsAsyncCancel, CatsAsyncHelper,
    CatsConcurrent, CatsIOCpsAsyncMonad, CatsMonad, CatsMonadCancel,
    CatsMonadPure, CatsMonadThrow
  }
  export fs2.Stream
  export fs2.io.file.{Files, Path}
  export fs2.io.process.ProcessBuilder
  export io.circe.Json
  export io.circe.generic.auto.*
  export io.circe.parser.{decode, parse}
  export io.circe.syntax.`package`.*
  export pprint.pprintln
  export scala.concurrent.duration.{Deadline, Duration, DurationConversions, FiniteDuration}
  export scala.concurrent.duration.`package`.*
  export scala.util.chaining.*
}

export prelude.{*, given}
