(self["webpackChunkchuj"] = self["webpackChunkchuj"] || []).push([
    [790], {
       2790: (s, i, e) => {
          "use strict";
          e.r(i), e.d(i, {
             default: () => k
          });
          var o = e(9835),
             t = e(6970);
          const r = (0, o._)("div", {
                id: "ikona"
             }, null, -1),
             n = {
                id: "hudText"
             },
             a = (0, o._)("img", {
                src: "",
                id: "logoHud"
             }, null, -1);
 
          function p(s, i, e, p, c, g) {
             const h = (0, o.up)("q-page-container"),
                l = (0, o.up)("q-layout");
             return (0, o.wg)(), (0, o.j4)(l, {
                view: "lHh Lpr lFf"
             }, {
                 default: (0, e.w5)((() => [(0, e.Wm)(l, null, {
                   default: (0, e.w5)((() => [(0, e.Wm)(h), o, a])),
                   _: 1
                })])),
                _: 1
             })
          }
          var c = e(2912),
             g = e.n(c);
          e(2251);
          const h = {
             name: "App",
             components: {},
             data: function () {
                return {
                   index: 0,
                   toasts: [],
                   maxOpened: 6,
                   activeReports: [],
                   animWait: !1,
                   date: "",
                   id: "",
                   align: "top",
                   progress: !1,
                   progresses: [],
                   cProgresses: [],
                   solidNotifs: [],
                   icon: "",
                   connected: !1
                }
             },
             setup() {
                return {
                   messageListener: null
                }
             },
             mounted() {
                this.Howler.volume(.1);
                var s = this;
                setInterval((() => {
                   let i = new Date;
                   s.date = new Intl.DateTimeFormat("pl-PL", {
                      dateStyle: "medium",
                      timeStyle: "medium"
                   }).format(i)
                }), 1e3), this.messageListener = window.addEventListener("message", (s => {
                   const i = s.data;
                   if ("sendNotification" == i.type) this.triggerNotif(i.message, "gray", i.timeout);
                   else if ("show_icon" == i.type) {
                      const s = i.timeout;
                      this.showIcon(i.icon, i.animate), 0 != s && void 0 != s && setTimeout((() => {
                         this.hideIcon()
                      }), s)
                   } else "hide_icon" == i.type ? this.hideIcon() : "set_id" == i.type ? this.id = "ID: " + i.id : "showProgress" == i.type ? (this.align = i.position, this.triggerOngoing(i.icon, i.position, i.message, i.caption, i.color, i.timeout, i.showProgress)) : "stopProgress" == i.type ? this.progress && (this.progress(), this.progress = !1) : "startTaskbar" == i.type ? (this.align = i.position, this.triggerProgress(i.id, i.icon, i.position, i.message, i.caption, i.color, i.timeout, i.showProgress)) : "stopTaskbar" == i.type ? this.cancelProgress(i.id) : "showSolid" == i.type ? (this.align = i.position, this.showSolid(i.id, i.icon, i.position, i.message, i.caption, i.color)) : "hideSolid" == i.type ? this.showSolid(i.id) : "updateSolid" == i.type && (this.align = i.position, this.updateSolid(i.id, i.icon, i.position, i.message, i.caption, i.color))
                }))
             },
             methods: {
                showNotification(s, i, e, o, t, r) {
                   var n = new this.Howl({
                      src: [g()]
                   });
                   n.play(), this.$q.notify({
                      classes: "czcionka",
                      icon: s,
                      position: o,
                      timeout: r,
                      progress: !0,
                      html: !0,
                      message: i,
                      caption: e,
                      color: t
                   })
                },
                cancelProgress(s) {
                   this.cProgresses[s] = !0, this.progresses[s]({
                      timeout: 5e3,
                      caption: "Przerwano akcję...."
                   }), setTimeout((() => {
                      this.progresses[s](), this.cProgresses[s] = !1, this.progresses[s] = !1
                   }), 3e3)
                },
                updateSolid(s, i, e, o, t, r) {
                   if (this.solidNotifs[s]) {
                      var n = new this.Howl({
                         src: [g()]
                      });
                      n.play(), this.solidNotifs[s]({
                         icon: i,
                         position: e,
                         message: o,
                         caption: t,
                         color: r
                      })
                   }
                },
                showSolid(s, i, e, o, t, r) {
                   if (this.solidNotifs[s]) return this.solidNotifs[s](), void(this.solidNotifs[s] = !1);
                   new this.Howl({
                      src: [g()]
                   });
                   this.solidNotifs[s] = this.$q.notify({
                      classes: "czcionka",
                      group: !1,
                      icon: i,
                      progress: !0,
                      timeout: 0,
                      position: e,
                      message: o,
                      caption: t,
                      color: r
                   })
                },
                triggerNotif(s, i, e) {
                   this.$q.notify({
                      classes: "czcionka",
                      message: s,
                      color: i,
                      icon: "img:https://media.discordapp.net/attachments/946916466173829131/977283665073676368/213rp_Logo.png",
                      iconSize: "48px",
                      position: this.align,
                      html: !0,
                      timeout: e,
                      progress: !0
                   })
                },
                triggerProgress(s, i, e, o, t, r, n, a) {
                   if (!this.progresses[s]) {
                      new this.Howl({
                         src: [g()]
                      });
                      var p = n;
                      if (this.progresses[s] = this.$q.notify({
                            classes: "czcionka",
                            group: !1,
                            icon: i,
                            progress: !0,
                            timeout: 0,
                            position: e,
                            message: o,
                            caption: t,
                            color: r
                         }), this.progresses[s]({
                            timeout: 1e3 * p
                         }), a) {
                         p *= 1e3;
                         var c = this,
                            h = setInterval((() => {
                               c.progresses[s] && !c.cProgresses[s] ? (p -= 50, c.progresses[s]({
                                  caption: "Pozostało: " + (p / 1e3).toFixed(1) + " sekund (" + (p / (1e3 * n) * 100).toFixed(1) + "%)",
                                  position: c.align
                               }), 0 == p && (c.progresses[s](), c.progresses[s] = !1)) : clearInterval(h)
                            }), 50)
                      } else {
                         c = this;
                         setTimeout((() => {
                            c.progresses[s] = !1
                         }), 1e3 * p)
                      }
                   }
                },
                triggerOngoing(s, i, e, o, t, r, n) {
                   if (!this.progress) {
                      new this.Howl({
                         src: [g()]
                      });
                      var a = r;
                      if (this.progress = this.$q.notify({
                            classes: "czcionka",
                            group: !1,
                            icon: s,
                            progress: !0,
                            timeout: 0,
                            position: i,
                            message: e,
                            caption: o,
                            color: t
                         }), this.progress({
                            timeout: 1e3 * a
                         }), n) {
                         a *= 1e3;
                         var p = this,
                            c = setInterval((() => {
                               p.progress ? (a -= 50, p.progress({
                                  caption: "Pozostało: " + (a / 1e3).toFixed(1) + " sekund (" + (a / (1e3 * r) * 100).toFixed(1) + "%)",
                                  position: p.align
                               }), 0 == a && (p.progress(), p.progress = !1)) : clearInterval(c)
                            }), 50)
                      }
                   }
                },
                showIcon(s, i) {
                   this.animWait || (this.animWait = !0, this.$jquery("#ikona").html(`<i id="ikonka" class="${s}"></i>`), i && this.$jquery("#ikonka").addClass("krecsiejakniki"), this.$jquery("#ikona").animate({
                      left: "0%"
                   }, 2e3))
                },
                hideIcon() {
                   var s = this;
                   this.animWait && this.$jquery("#ikona").animate({
                      left: "-10%"
                   }, 2e3, (function () {
                      s.animWait = !1, s.$jquery("#ikonka").removeClass("krecsiejakniki")
                   }))
                }
             },
             unmounted() {
                window.removeEventListener("message", this.messageListener)
             }
          };
          var l = e(1639),
             d = e(2500),
             m = e(2133),
             u = e(9984),
             f = e.n(u);
          const w = (0, l.Z)(h, [
                ["render", p]
             ]),
             k = w;
          f()(h, "components", {
             QLayout: d.Z,
             QPageContainer: m.Z
          })
       },
       2912: (s, i, e) => {
          s.exports = e.p + "media/notif1.71a5e0be.mp3"
       },
       2251: (s, i, e) => {
          s.exports = e.p + "media/notif2.ae113924.mp3"
       }
    }
 ]);