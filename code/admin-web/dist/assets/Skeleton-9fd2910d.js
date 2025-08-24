import{bn as P,J as f,E as N,d as R,K as A,L as y,c1 as E,k as H,Q as O,b6 as b,S as p,T,F as V}from"./index-abec4112.js";let k=!1;function _(){if(P&&window.CSS&&!k&&(k=!0,"registerProperty"in(window==null?void 0:window.CSS)))try{CSS.registerProperty({name:"--n-color-start",syntax:"<color>",inherits:!1,initialValue:"#0000"}),CSS.registerProperty({name:"--n-color-end",syntax:"<color>",inherits:!1,initialValue:"#0000"})}catch{}}const j=f([N("skeleton",`
 height: 1em;
 width: 100%;
 transition: background-color .3s var(--n-bezier);
 transition:
 --n-color-start .3s var(--n-bezier),
 --n-color-end .3s var(--n-bezier),
 background-color .3s var(--n-bezier);
 animation: 2s skeleton-loading infinite cubic-bezier(0.36, 0, 0.64, 1);
 background-color: var(--n-color-start);
 `),f("@keyframes skeleton-loading",`
 0% {
 background: var(--n-color-start);
 }
 40% {
 background: var(--n-color-end);
 }
 80% {
 background: var(--n-color-start);
 }
 100% {
 background: var(--n-color-start);
 }
 `)]),F=Object.assign(Object.assign({},y.props),{text:Boolean,round:Boolean,circle:Boolean,height:[String,Number],width:[String,Number],size:String,repeat:{type:Number,default:1},animated:{type:Boolean,default:!0},sharp:{type:Boolean,default:!0}}),L=R({name:"Skeleton",inheritAttrs:!1,props:F,setup(e){_();const{mergedClsPrefixRef:o}=A(e),i=y("Skeleton","-skeleton",j,E,e,o);return{mergedClsPrefix:o,style:H(()=>{var t,r;const s=i.value,{common:{cubicBezierEaseInOut:v}}=s,g=s.self,{color:S,colorEnd:w,borderRadius:x}=g;let a;const{circle:l,sharp:z,round:C,width:n,height:c,size:h,text:m,animated:B}=e;h!==void 0&&(a=g[O("height",h)]);const d=l?(t=n??c)!==null&&t!==void 0?t:a:n,u=(r=l?n??c:c)!==null&&r!==void 0?r:a;return{display:m?"inline-block":"",verticalAlign:m?"-0.125em":"",borderRadius:l?"50%":C?"4096px":z?"":x,width:typeof d=="number"?b(d):d,height:typeof u=="number"?b(u):u,animation:B?"":"none","--n-bezier":v,"--n-color-start":S,"--n-color-end":w}})}},render(){const{repeat:e,style:o,mergedClsPrefix:i,$attrs:t}=this,r=p("div",T({class:`${i}-skeleton`,style:o},t));return e>1?p(V,null,Array.apply(null,{length:e}).map(s=>[r,`
`])):r}});export{L as N};
