using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostProcessSubsurfaceScattering: MonoBehaviour 
{
    [SerializeField]
    private Shader m_shaderDepth;
    [SerializeField]
    private Camera m_camDepthCamera;
    [SerializeField]
    private RenderTexture m_texDepthMap;
    [SerializeField]
    private Material m_matSubSurfaceMaterial;

    public bool m_bDebugDepth = false;

	// Use this for initialization
	void Start () 
    {
		if(m_texDepthMap == null || m_matSubSurfaceMaterial == null)
        {
            Debug.LogError("DepthMap or SubsurfaceMaterial were not assigned");
        }
        //m_camDepthCamera.SetReplacementShader(m_shaderDepth, null);
    }

    void OnPreCull()
    {

        //m_camDepthCamera.targetTexture = m_texDepthMap;
        //m_camDepthCamera.Render();

        m_matSubSurfaceMaterial.SetTexture("_DepthMap", m_texDepthMap);
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (m_bDebugDepth)
        {
            Graphics.Blit(m_texDepthMap, destination);

            return;
        }

        if(m_texDepthMap)
        {
            m_matSubSurfaceMaterial.SetTexture("_DepthMap", m_texDepthMap);
        }
        m_matSubSurfaceMaterial.SetMatrix("_LightMatrix", m_camDepthCamera.worldToCameraMatrix);
        m_matSubSurfaceMaterial.SetMatrix("_LightProjectionMatrix", GL.GetGPUProjectionMatrix(m_camDepthCamera.projectionMatrix, false));
        m_matSubSurfaceMaterial.SetMatrix("_LightTexMatrix", m_camDepthCamera.projectionMatrix * m_camDepthCamera.worldToCameraMatrix);
    }
}
