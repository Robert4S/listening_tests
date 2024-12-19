let Hooks = {};
Hooks.AudioHook = {
  mounted() {
    let audio_elem;
    const play = () => audio_elem.play();
    const pause = () => audio_elem.pause();
    const scrubTo = (time) => audio_elem.currentTime = time;

    window.addEventListener("phx:play", (_e) => play());

    window.addEventListener("phx:pause", (_e) => pause());

    window.addEventListener("phx:set_source", (e) => {
      let src = e.detail.source;
      audio_elem = new Audio(`/uploads/${src}`);
    });

    window.addEventListener("phx:scrub_to", (e) => scrubTo(e.detail.time))
  }
}

Hooks.MasterAudioHook = {
  mounted() {
    this.el.addEventListener('play', (_e) => {
      this.pushEvent("play", {});
    });

    this.el.addEventListener("pause", (_e) => {
      this.pushEvent("pause", {});
    });

    this.el.addEventListener("seeked", (_e) => {
      new_time = this.el.currentTime;
      this.pushEvent("scrub", { "time": new_time })
    });

    window.addEventListener("phx:playback", (e) => {
      let pid = e.detail.pid;
      let time = this.el.currentTime;
      let state = this.el.paused ? "paused" : "played";
      this.pushEvent("playback", { "time": time, "state": state, "pid": pid });
    });
  }
}

export default Hooks;
