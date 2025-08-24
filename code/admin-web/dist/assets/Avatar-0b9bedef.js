import{bn as K,aM as V,E as _,ce as G,J as F,cf as q,G as $,d as D,K as J,m as R,aN as A,k as x,L as B,cg as Q,n as U,Q as X,R as Y,cb as Z,p as ee,aR as re,bk as oe,V as te,a0 as ne,S as O,ch as se,bo as ae}from"./index-abec4112.js";const k=K&&"loading"in document.createElement("img"),ie=(e={})=>{var i;const{root:d=null}=e;return{hash:`${e.rootMargin||"0px 0px 0px 0px"}-${Array.isArray(e.threshold)?e.threshold.join(","):(i=e.threshold)!==null&&i!==void 0?i:"0"}`,options:Object.assign(Object.assign({},e),{root:(typeof d=="string"?document.querySelector(d):d)||document.documentElement})}},M=new WeakMap,P=new WeakMap,C=new WeakMap,le=(e,i,d)=>{if(!e)return()=>{};const s=ie(i),{root:c}=s.options;let a;const u=M.get(c);u?a=u:(a=new Map,M.set(c,a));let h,n;a.has(s.hash)?(n=a.get(s.hash),n[1].has(e)||(h=n[0],n[1].add(e),h.observe(e))):(h=new IntersectionObserver(m=>{m.forEach(f=>{if(f.isIntersecting){const p=P.get(f.target),g=C.get(f.target);p&&p(),g&&(g.value=!0)}})},s.options),h.observe(e),n=[h,new Set([e])],a.set(s.hash,n));let b=!1;const z=()=>{b||(P.delete(e),C.delete(e),b=!0,n[1].has(e)&&(n[0].unobserve(e),n[1].delete(e)),n[1].size<=0&&a.delete(s.hash),a.size||M.delete(c))};return P.set(e,z),C.set(e,d),z},de=V("n-avatar-group"),ce=_("avatar",`
 width: var(--n-merged-size);
 height: var(--n-merged-size);
 color: #FFF;
 font-size: var(--n-font-size);
 display: inline-flex;
 position: relative;
 overflow: hidden;
 text-align: center;
 border: var(--n-border);
 border-radius: var(--n-border-radius);
 --n-merged-color: var(--n-color);
 background-color: var(--n-merged-color);
 transition:
 border-color .3s var(--n-bezier),
 background-color .3s var(--n-bezier),
 color .3s var(--n-bezier);
`,[G(F("&","--n-merged-color: var(--n-color-modal);")),q(F("&","--n-merged-color: var(--n-color-popover);")),F("img",`
 width: 100%;
 height: 100%;
 `),$("text",`
 white-space: nowrap;
 display: inline-block;
 position: absolute;
 left: 50%;
 top: 50%;
 `),_("icon",`
 vertical-align: bottom;
 font-size: calc(var(--n-merged-size) - 6px);
 `),$("text","line-height: 1.25")]),ue=Object.assign(Object.assign({},B.props),{size:[String,Number],src:String,circle:{type:Boolean,default:void 0},objectFit:String,round:{type:Boolean,default:void 0},bordered:{type:Boolean,default:void 0},onError:Function,fallbackSrc:String,intersectionObserverOptions:Object,lazy:Boolean,onLoad:Function,renderPlaceholder:Function,renderFallback:Function,imgProps:Object,color:String}),ve=D({name:"Avatar",props:ue,setup(e){const{mergedClsPrefixRef:i,inlineThemeDisabled:d}=J(e),s=R(!1);let c=null;const a=R(null),u=R(null),h=()=>{const{value:r}=a;if(r&&(c===null||c!==r.innerHTML)){c=r.innerHTML;const{value:o}=u;if(o){const{offsetWidth:l,offsetHeight:t}=o,{offsetWidth:v,offsetHeight:L}=r,S=.9,j=Math.min(l/v*S,t/L*S,1);r.style.transform=`translateX(-50%) translateY(-50%) scale(${j})`}}},n=A(de,null),b=x(()=>{const{size:r}=e;if(r)return r;const{size:o}=n||{};return o||"medium"}),z=B("Avatar","-avatar",ce,se,e,i),m=A(Q,null),f=x(()=>{if(n)return!0;const{round:r,circle:o}=e;return r!==void 0||o!==void 0?r||o:m?m.roundRef.value:!1}),p=x(()=>n?!0:e.bordered||!1),g=r=>{var o;if(!E.value)return;s.value=!0;const{onError:l,imgProps:t}=e;(o=t==null?void 0:t.onError)===null||o===void 0||o.call(t,r),l&&l(r)};U(()=>e.src,()=>s.value=!1);const H=x(()=>{const r=b.value,o=f.value,l=p.value,{color:t}=e,{self:{borderRadius:v,fontSize:L,color:S,border:j,colorModal:I,colorPopover:W},common:{cubicBezierEaseInOut:N}}=z.value;let w;return typeof r=="number"?w=`${r}px`:w=z.value.self[X("height",r)],{"--n-font-size":L,"--n-border":l?j:"none","--n-border-radius":o?"50%":v,"--n-color":t||S,"--n-color-modal":t||I,"--n-color-popover":t||W,"--n-bezier":N,"--n-merged-size":`var(--n-avatar-size-override, ${w})`}}),y=d?Y("avatar",x(()=>{const r=b.value,o=f.value,l=p.value,{color:t}=e;let v="";return r&&(typeof r=="number"?v+=`a${r}`:v+=r[0]),o&&(v+="b"),l&&(v+="c"),t&&(v+=Z(t)),v}),H,e):void 0,E=R(!e.lazy);ee(()=>{if(k)return;let r;const o=re(()=>{r==null||r(),r=void 0,e.lazy&&(r=le(u.value,e.intersectionObserverOptions,E))});oe(()=>{o(),r==null||r()})});const T=R(!e.lazy);return{textRef:a,selfRef:u,mergedRoundRef:f,mergedClsPrefix:i,fitTextTransform:h,cssVars:d?void 0:H,themeClass:y==null?void 0:y.themeClass,onRender:y==null?void 0:y.onRender,hasLoadError:s,handleError:g,shouldStartLoading:E,loaded:T,mergedOnLoad:r=>{var o;const{onLoad:l,imgProps:t}=e;l==null||l(r),(o=t==null?void 0:t.onLoad)===null||o===void 0||o.call(t,r),T.value=!0}}},render(){var e,i;const{$slots:d,src:s,mergedClsPrefix:c,lazy:a,onRender:u,mergedOnLoad:h,shouldStartLoading:n,loaded:b,hasLoadError:z}=this;u==null||u();let m;const f=!b&&!z&&(this.renderPlaceholder?this.renderPlaceholder():(i=(e=this.$slots).placeholder)===null||i===void 0?void 0:i.call(e));return this.hasLoadError?m=this.renderFallback?this.renderFallback():te(d.fallback,()=>[O("img",{src:this.fallbackSrc,style:{objectFit:this.objectFit}})]):m=ne(d.default,p=>{if(p)return O(ae,{onResize:this.fitTextTransform},{default:()=>O("span",{ref:"textRef",class:`${c}-avatar__text`},p)});if(s){const{imgProps:g}=this;return O("img",Object.assign(Object.assign({},g),{loading:k&&!this.intersectionObserverOptions&&a?"lazy":"eager",src:k||n||b?s:void 0,onLoad:h,"data-image-src":s,onError:this.handleError,style:[g==null?void 0:g.style,{objectFit:this.objectFit},f?{height:"0",width:"0",visibility:"hidden",position:"absolute"}:""]}))}}),O("span",{ref:"selfRef",class:[`${c}-avatar`,this.themeClass],style:this.cssVars},m,a&&f)}});export{ve as N,k as i,le as o};
