{$ifdef CLR}
    {$DEFINE DELPHI_NET}
    {$DEFINE NET_registered}
{$endif}

{$ifndef DELPHI_NET}
    {$ifndef WIN32}
        {$ifndef LINUX}
            {$define WIN32}
        {$endif}
    {$endif}
{$endif}

// we currently support Linux only on x86
{$ifdef LINUX}
{$define SB_X86ASM}
{$endif}

{$ifdef WIN32}
{$define SB_X86ASM}
{$endif}

// by default we are on 32-bit CPU
{$define SB_CPU32}

{$ifdef CPU64}
{$define SB_CPU64}
{$undef SB_CPU32}
{$endif}

{$ifndef CLR}
{$ifndef FPC}
{$define DELPHI_WIN}
{$endif}
{$endif}

{$IFDEF FPC} // set mode only with FreePascal, since Delphi doesn't know it
{$MODE DELPHI}
{$ENDIF FPC}

{$IFDEF VER120}
  {$DEFINE D_3_UP}
  {$DEFINE D_4_UP}
  {$DEFINE VCL40}
{$ENDIF}

{$IFDEF VER125}
  {$DEFINE B_3_UP}
  {$DEFINE B_4_UP}
  {$DEFINE B_4}
  {$DEFINE VCL40}
  {$DEFINE BUILDER_USED}
{$ENDIF}

{$IFDEF VER130}
	{$IFDEF BCB}
		{$DEFINE B_3_UP}
		{$DEFINE B_4_UP}
		{$DEFINE B_5_UP}
		{$DEFINE B_5}
		{$DEFINE VCL40}
		{$DEFINE VCL50}
		{$DEFINE BUILDER_USED}
    {$ELSE}
		{$DEFINE D_3_UP}
		{$DEFINE D_4_UP}
		{$DEFINE D_5_UP}
		{$DEFINE VCL40}
		{$DEFINE VCL50}
		{.DEFINE USEADO}
    {$ENDIF}
{$ENDIF}

{$IFDEF VER140}
	{$IFDEF BCB}
		{$DEFINE B_3_UP}
		{$DEFINE B_4_UP}
		{$DEFINE B_5_UP}
		{$DEFINE B_6_UP}
		{$DEFINE B_6}
		{$DEFINE VCL40}
		{$DEFINE VCL50}
		{$DEFINE VCL60}
		{$DEFINE BUILDER_USED}
    {$ELSE}
		{$DEFINE D_3_UP}
		{$DEFINE D_4_UP}
		{$DEFINE D_5_UP}
		{$DEFINE D_6_UP}
		{$DEFINE D_6}
		{$DEFINE VCL40}
		{$DEFINE VCL50}
		{$DEFINE VCL60}
		{.DEFINE USEADO}
    {$ENDIF}
{$ENDIF}


{$IFDEF VER150}
	{$IFNDEF BCB}
		{$DEFINE D_3_UP}
		{$DEFINE D_4_UP}
		{$DEFINE D_5_UP}
		{$DEFINE D_6_UP}
		{$DEFINE D_7_UP}
		{$DEFINE D_7}
		{$DEFINE VCL40}
		{$DEFINE VCL50}
		{$DEFINE VCL60}
		{$DEFINE VCL70}
		{.DEFINE USEADO}
    {$ENDIF}
{$ENDIF}

{$IFDEF VER160}
    {$DEFINE D_3_UP}
    {$DEFINE D_4_UP}
    {$DEFINE D_5_UP}
    {$DEFINE D_6_UP}
    {$DEFINE D_7_UP}
    {$DEFINE D_8_UP}
    {$DEFINE D_8}
    {$DEFINE VCL40}
    {$DEFINE VCL50}
    {$DEFINE VCL60}
    {$DEFINE VCL70}
    {$DEFINE VCL80}
    {.$DEFINE USE_NAME_SPACE} // Optional !!!
{$ENDIF}

{$IFDEF VER170}
    {$DEFINE D_3_UP}
    {$DEFINE D_4_UP}
    {$DEFINE D_5_UP}
    {$DEFINE D_6_UP}
    {$DEFINE D_7_UP}
    {$DEFINE D_8_UP}
    {$DEFINE D_9_UP}
    {$DEFINE D_9}
    {$DEFINE VCL40}
    {$DEFINE VCL50}
    {$DEFINE VCL60}
    {$DEFINE VCL70}
    {$DEFINE VCL80}
    {$DEFINE VCL90}
    {.$DEFINE USE_NAME_SPACE} // Optional !!!
{$ENDIF}

{$IFDEF VER180}
    {$DEFINE D_3_UP}
    {$DEFINE D_4_UP}
    {$DEFINE D_5_UP}
    {$DEFINE D_6_UP}
    {$DEFINE D_7_UP}
    {$DEFINE D_8_UP}
    {$DEFINE D_9_UP}
    {$DEFINE D_X_UP}
    {$DEFINE D_X}
    {$DEFINE VCL40}
    {$DEFINE VCL50}
    {$DEFINE VCL60}
    {$DEFINE VCL70}
    {$DEFINE VCL80}
    {$DEFINE VCL90}
    {$DEFINE VCL100}

    {$DEFINE B_3_UP}
    {$DEFINE B_4_UP}
    {$DEFINE B_5_UP}
    {$DEFINE B_6_UP}
    {$DEFINE B_X_UP}
    {$DEFINE B_X}
    {$ifndef DELPHI_NET}	    
    {$DEFINE BUILDER_USED}
    {$endif}
{$ENDIF}

{$IFDEF VER190}
    {$DEFINE D_3_UP}
    {$DEFINE D_4_UP}
    {$DEFINE D_5_UP}
    {$DEFINE D_6_UP}
    {$DEFINE D_7_UP}
    {$DEFINE D_8_UP}
    {$DEFINE D_9_UP}
    {$DEFINE D_X_UP}
    {$DEFINE D_11_UP}
    {$DEFINE D_11}
    {$DEFINE VCL40}
    {$DEFINE VCL50}
    {$DEFINE VCL60}
    {$DEFINE VCL70}
    {$DEFINE VCL80}
    {$DEFINE VCL90}
    {$DEFINE VCL100}
    {$DEFINE VCL110}

    {$DEFINE B_3_UP}
    {$DEFINE B_4_UP}
    {$DEFINE B_5_UP}
    {$DEFINE B_6_UP}
    {$DEFINE B_X_UP}
    {$DEFINE B_11_UP}
    {$DEFINE B_11}
    {$ifndef DELPHI_NET}	    
    {$DEFINE BUILDER_USED}
    {$endif}
{$ENDIF}
    
{$ifndef CHROME}
{$ifndef DELPHI_NET}
{$IFDEF D_7_UP}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CAST OFF}
{$ENDIF}
{$ENDIF}
{$ENDIF}

{$ifdef DELPHI_NET}
{$undef SB_ACTIVEX_MODE}
{$endif}

{$ifdef LINUX}
{$define KYLIX_USED}
{$define CLX_USED}
{$else}
{$define MSWINDOWS}
{$endif}

{$ifndef CHROME}
{$ifdef BUILDER_USED}
{$OBJEXPORTALL ON}
{$endif}
{$endif}

{.$define SBB_EVAL}

{$ifndef CHROME}
  {$ifndef FPC}
    {$Q-,R-,I-,J-}
  {$endif}
{$endif}

// since there's no PGP in C++Builder 4 and 5, we exclude it's use from XML
{$ifdef B_4}
  {$define SBB_EXCL_XML_PGP}
{$endif}
{$ifdef B_5}
  {$define SBB_EXCL_XML_PGP}
  {.$define SBB_EXCL_XPATH}
  {.$define SBB_NO_PKCS11}
{$endif}
{$ifdef B_6}
  {$define SBB_NO_PKCS11}
{$endif}

{$DEFINE COMPLEXENCODING_SUPPORT}

{$ifndef LINUX}
{$ifndef DELPHI_NET}
{$DEFINE NTLM_SUPPORT}
{$endif}
{$endif}

{$ifdef LINUX}
{$undef NTLM_SUPPORT}
{$endif}

{$define HAS_DEF_PARAMS}
{$define SB_HAS_WINCRYPT}

{$ifdef CLX_USED}
  {$undef SB_HAS_WINCRYPT}
{$endif}

{$ifdef MONO}
  {$undef SB_HAS_WINCRYPT}
  {$define SBB_NO_PKCS11}
{$endif}

{$ifdef FPC}
  {$ifndef WIN32}
  {$undef SB_HAS_WINCRYPT}
  {$define SBB_NO_PKCS11}
  {$endif}
  {$undef NTLM_SUPPORT}
{$endif}

{$undef TriDES_KEY_AS_REC}
{$ifdef CHROME}
  {$ifdef MONO}
    {$define TriDES_KEY_AS_REC}
  {$endif}
  {$ifdef NET_CF_1_0}
    {$define TriDES_KEY_AS_REC}
  {$endif}
{$endif}

{$ifdef CHROME}
  {$ifdef MONO}
    {$define SBB_NO_PKCS11}
	{$undef SB_HAS_WINCRYPT}
  {$endif}
  {$ifdef NET_CF}
    {$define SBB_NO_PKCS11}
  {$endif}
{$endif}

{.$DEFINE SECURE_BLACKBOX_DEBUG}

{.$define SBB_NO_DES}
{.$define SBB_NO_RC2}
{.$define SBB_NO_RC4}
{.$define SBB_NO_IDEA}
{.$define SBB_NO_CAMELLIA}
{.$define SBB_NO_SEED}
{.$define SBB_NO_SRP}
{.$define SBB_EXCL_XADES_INTF}

{$ifdef SBB_EXCL_XADES}
{$define SBB_EXCL_XADES_INTF}
{$endif}

{$ifdef SB_ACTIVEX_MODE}
{$define SBB_NO_SRP}
{$endif}
