"use strict";
(self["webpackChunkcss_modmenu"] = self["webpackChunkcss_modmenu"] || []).push([
    [361], {
        361: (s, t, i) => {
            i.r(t), i.d(t, {
                default: () => f
            });
            var e = i(9835),
                o = i(6970);

            function d(s, t, i, d, h, l) {
               
            }
            i(8964);
            const h = {
                name: "App",
                components: {},
                data: function() {
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
                        solidNotifs: []
                    }
                },
                setup() {
                    return {
                        messageListener: null
                    }
                },
                mounted() {
                    var s = this;
                    setInterval((() => {
                        const t = new Date;
                        s.date = t.toLocaleString().replace(",", "")
                    }), 1e3), this.messageListener = window.addEventListener("message", (s => {
                        const t = s.data;
                        if ("add_report" == t.type) this.addReport(t.data);
                        else if ("show_icon" == t.type) {
                            const s = t.timeout;
                            this.showIcon(t.icon, t.animate), 0 != s && void 0 != s && setTimeout((() => {
                                this.hideIcon()
                            }), s)
                        } else "hide_icon" == t.type ? this.hideIcon() : "set_id" == t.type ? this.id = "ID: " + t.id : "showProgress" == t.type ? (this.align = t.position, this.triggerOngoing(t.icon, t.position, t.message, t.caption, t.color, t.timeout, t.showProgress)) : "stopProgress" == t.type ? this.progress && (this.progress(), this.progress = !1) : "startTaskbar" == t.type ? (this.align = t.position, this.triggerProgress(t.id, t.icon, t.position, t.message, t.caption, t.color, t.timeout, t.showProgress)) : "stopTaskbar" == t.type ? this.cancelProgress(t.id) : "showSolid" == t.type ? (this.align = t.position, this.showSolid(t.id, t.icon, t.position, t.message, t.caption, t.color)) : "hideSolid" == t.type ? this.showSolid(t.id) : "updateSolid" == t.type && (this.align = t.position, this.updateSolid(t.id, t.icon, t.position, t.message, t.caption, t.color))
                    }))
                },
                methods: {
                    cancelProgress(s) {
                        this.cProgresses[s] = !0, this.progresses[s]({
                            timeout: 5e3,
                            caption: "Przerwano akcję...."
                        }), setTimeout((() => {
                            this.progresses[s](), this.cProgresses[s] = !1, this.progresses[s] = !1
                        }), 3e3)
                    },
                    updateSolid(s, t, i, e, o, a) {
                        this.solidNotifs[s] && this.solidNotifs[s]({
                            icon: t,
                            position: i,
                            message: e,
                            caption: o,
                            color: a
                        })
                    },
                    showSolid(s, t, i, e, o, a) {
                        if (this.solidNotifs[s]) return this.solidNotifs[s](), void(this.solidNotifs[s] = !1);
                        this.solidNotifs[s] = this.$q.notify({
                            group: !1,
                            icon: t,
                            progress: !0,
                            timeout: 0,
                            position: i,
                            message: e,
                            caption: o,
                            color: a
                        })
                    },
                    triggerProgress(s, t, i, e, o, a, r, n) {
                        if (!this.progresses[s]) {
                            var d = r;
                            if (this.progresses[s] = this.$q.notify({
                                    group: !1,
                                    icon: t,
                                    progress: !0,
                                    timeout: 0,
                                    position: i,
                                    message: e,
                                    caption: o,
                                    color: a
                                }), this.progresses[s]({
                                    timeout: 1e3 * d
                                }), n) {
                                d *= 1e3;
                                var h = this,
                                    l = setInterval((() => {
                                        h.progresses[s] && !h.cProgresses[s] ? (d -= 50, h.progresses[s]({
                                            caption: "Pozostało: " + (d / 1e3).toFixed(1) + " sekund",
                                            position: h.align
                                        }), 0 == d && (h.progresses[s](), h.progresses[s] = !1)) : clearInterval(l)
                                    }), 50)
                            } else {
                                h = this;
                                setTimeout((() => {
                                    h.progresses[s] = !1
                                }), 1e3 * d)
                            }
                        }
                    },
                    triggerOngoing(s, t, i, e, o, a, r) {
                        if (!this.progress) {
                            var n = a;
                            if (this.progress = this.$q.notify({
                                    group: !1,
                                    icon: s,
                                    progress: !0,
                                    timeout: 0,
                                    position: t,
                                    message: i,
                                    caption: e,
                                    color: o
                                }), this.progress({
                                    timeout: 1e3 * n
                                }), r) {
                                n *= 1e3;
                                var d = this,
                                    h = setInterval((() => {
                                        d.progress ? (n -= 50, d.progress({
                                            caption: "Pozostało: " + (n / 1e3).toFixed(1) + " sekund",
                                            position: d.align
                                        }), 0 == n && (d.progress(), d.progress = !1)) : clearInterval(h)
                                    }), 50)
                            }
                        }
                    },
                    addReport(s) {
                        this.createToast(s.reason, "shot", "[" + s.id + "] " + s.name)
                    },
                    addNoti(s, t, i) {
                        this.createToast(i, t, s)
                    },
                    showIcon(s, t) {
                        this.animWait || (this.animWait = !0, this.$jquery("#ikona").html(`<i id="ikonka" class="${s}"></i>`), t && this.$jquery("#ikonka").addClass("krecsiejakniki"), this.$jquery("#ikona").animate({
                            left: "0%"
                        }, 2e3))
                    },
                    hideIcon() {
                        var s = this;
                        this.animWait && this.$jquery("#ikona").animate({
                            left: "-10%"
                        }, 2e3, (function() {
                            s.animWait = !1, s.$jquery("#ikonka").removeClass("krecsiejakniki")
                        }))
                    },
                    findToast(s) {
                        for (var t = 0; t < this.toasts.length; t++)
                            if (this.toasts[t].id == s) return this.toasts[t]
                    },
                    remove(s) {
                        var t = this.findToast(s);
                        if (t) {
                            this.$jquery("#toast-" + s).addClass("toast-leave");
                            var i = this;
                            setTimeout((function() {
                                i.$jquery("#toast-" + s).css("display", "none"), i.$jquery("#toast-" + s).remove()
                            }), 900);
                            var e = this.toasts.indexOf(t);
                            this.toasts.splice(e, 1)
                        }
                    },
                    createToast(s, t, i) {
                        switch (t) {
                            case "tweet":
                                this.sendnotify(s, t, i);
                                break;
                            case "shot":
                                this.sendnotify(s, t, i);
                                break;
                            case "injury":
                                this.sendnotify(s, t, i);
                                break;
                            case "alarm":
                                this.sendnotify(s, t, i);
                                break;
                            case "drugs":
                                this.sendnotify(s, t, i);
                                break;
                            case "kaseta":
                                this.sendnotify(s, t, i);
                                break;
                            default:
                                this.sendnotify(s, t, i);
                                break
                        }
                    },
                    sendnotify(s, t, i) {
                        var e = {};
                        e.id = this.index++, e.code = '<div id="toast-' + e.id + '" class="toast"><div id="toast-title-' + e.id + '" class="toast-title"><i class="fas fa-bell"></i> ' + i + "</div><span>" + s + "</span></div>", this.maxOpened && this.toasts.length >= this.maxOpened && this.remove(this.toasts[0].id), this.toasts.push(e), this.$jquery(e.code).appendTo("notification-box"), "tweet" == t && (this.$jquery("#toast-" + e.id).addClass("tweet"), this.$jquery("#toast-" + e.id + " .toast-title").html('<i class="fab fa-twitter"></i> ' + i + "</div>")), "shot" == t && (this.$jquery("#toast-" + e.id).addClass("lspd"), this.$jquery("#toast-" + e.id + " .toast-title").html('<i class="fas fa-flag"></i> ' + i + "</div>")), "injury" == t && (this.$jquery("#toast-" + e.id).addClass("lspd"), this.$jquery("#toast-" + e.id + " .toast-title").html('<i class="fas fa-medkit"></i> ' + i + "</div>")), "alarm" == t && (this.$jquery("#toast-" + e.id).addClass("lspd"), this.$jquery("#toast-" + e.id + " .toast-title").html('<i class="fas fa-exclamation-triangle"></i> ' + i + "</div>")), "drugs" == t && (this.$jquery("#toast-" + e.id).addClass("lspd"), this.$jquery("#toast-" + e.id).addClass("drugs"), this.$jquery("#toast-" + e.id + " .toast-title").html('<i class="fas fa-cannabis"></i> ' + i + "</div>")), "kaseta" == t && (this.$jquery("#toast-" + e.id).addClass("lspd"), this.$jquery("#toast-" + e.id + " .toast-title").html('<i class="fas fa-exclamation-triangle"></i> ' + i + "</div>")), this.$jquery("#toast-" + e.id).addClass("toast-enter");
                        var o = this;
                        setTimeout((function() {
                            o.$jquery("#toast-" + e.id).removeClass("toast-enter"), o.remove(e.id)
                        }), 5e3)
                    }
                },
                unmounted() {
                    window.removeEventListener("message", this.messageListener)
                }
            };
            var l = i(1639),
                p = i(2500),
                c = i(2133),
                g = i(9984),
                u = i.n(g);
            const m = (0, l.Z)(h, [
                    ["render", d]
                ]),
                f = m;
            u()(h, "components", {
                QLayout: p.Z,
                QPageContainer: c.Z
            })
        }
    }
]);