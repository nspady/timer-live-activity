import React, {useCallback, useEffect} from 'react';
import {NativeEventEmitter, NativeModule, NativeModules} from 'react-native';

const {TimerWidgetModule} = NativeModules;

const TimerEventEmitter = new NativeEventEmitter(
  NativeModules.TimerEventEmitter as NativeModule,
);

const useTimer = () => {
  const [elapsedTimeInMs, setElapsedTimeInMs] = React.useState(0);
  const [isPlaying, setIsPlaying] = React.useState(false);
  const startTime = React.useRef<number | null>(null);
  const pausedTime = React.useRef<number | null>(null);

  const intervalId = React.useRef<NodeJS.Timeout | null>(null);

  const elapsedTimeInSeconds = Math.floor(elapsedTimeInMs / 1000);
  const milliseconds = Math.floor((elapsedTimeInMs % 1000) / 100);
  const seconds = elapsedTimeInSeconds % 60;
  const minutes = Math.floor(elapsedTimeInSeconds / 60);

  const value = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${milliseconds}`;

  const play = useCallback(() => {
    setIsPlaying(true);
    // Already playing, returning early
    if (intervalId.current) {
      return;
    }

    // First time playing, recording the start time
    if (!startTime.current) {
      startTime.current = Date.now();
    }

    if (pausedTime.current) {
      // If the timer is paused, we need to update the start time
      const elapsedSincePaused = Date.now() - pausedTime.current;
      startTime.current = startTime.current! + elapsedSincePaused;
      pausedTime.current = null;
      TimerWidgetModule.resume();
      console.log('resumed from pause');
    } else {
      TimerWidgetModule.startLiveActivity(startTime.current / 1000);
      console.log('started new');
    }

    intervalId.current = setInterval(() => {
      setElapsedTimeInMs(Date.now() - startTime.current!);
    }, 32);
  }, []);

  const pause = useCallback(() => {
    setIsPlaying(false);
    removeInterval();
    if (startTime.current && !pausedTime.current) {
      pausedTime.current = Date.now();
      TimerWidgetModule.pause(pausedTime.current / 1000);
      setElapsedTimeInMs(pausedTime.current! - startTime.current!);
    }
  }, []);

  const reset = useCallback(() => {
    setIsPlaying(false);
    removeInterval();
    startTime.current = null;
    pausedTime.current = null;
    setElapsedTimeInMs(0);
    TimerWidgetModule.stopLiveActivity();
  }, []);

  useEffect(() => {
    const pauseSubscription = TimerEventEmitter.addListener('onPause', pause);
    const resumeSubscription = TimerEventEmitter.addListener('onResume', play);
    const resetSubscription = TimerEventEmitter.addListener('onReset', reset);

    return () => {
      pauseSubscription.remove();
      resumeSubscription.remove();
      resetSubscription.remove();
    };
  }, [pause, reset, play]);

  function removeInterval() {
    if (intervalId.current) {
      clearInterval(intervalId.current);
      intervalId.current = null;
    }
  }

  return {
    play,
    pause,
    reset,
    value,
    isPlaying,
  };
};

export default useTimer;
