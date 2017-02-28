using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SSS_Controller : MonoBehaviour
{
    [SerializeField]
    private Transform m_transLightAnchor;

    private Camera m_cameraSSS;
    private Light m_lightSSS;

    [SerializeField]
    SSSObject[] m_arrsssObjects;
    [SerializeField]
    SSS_SubsurfaceScattering m_sssSubsurfaceScattering;
    [SerializeField]
    GameObject m_goDebugQuad;

    float fTurnSpeedY = 30.0f;
    float fTurnSpeedX = 20.0f;


    // Use this for initialization
    void Start ()
    {
        m_cameraSSS = m_transLightAnchor.GetComponentInChildren<Camera>();
        m_lightSSS = m_cameraSSS.GetComponentInChildren<Light>();

    }
	
	// Update is called once per frame
	void Update ()
    {
	    for(int i = 49; i < (49 + m_arrsssObjects.Length); i++)
        {
            if(Input.GetKeyDown((KeyCode)i))
            {
                m_arrsssObjects[i-49].Toggle(m_sssSubsurfaceScattering.m_arrmatSubSurfaceMaterials);
            }
        }

        if(Input.GetKey(KeyCode.LeftArrow))
        {
            m_transLightAnchor.Rotate(Vector3.up, -fTurnSpeedY * Time.deltaTime, Space.World);
        }

        if (Input.GetKey(KeyCode.RightArrow))
        {
            m_transLightAnchor.Rotate(Vector3.up, fTurnSpeedY * Time.deltaTime, Space.World);

        }

        if (Input.GetKey(KeyCode.UpArrow))
        {
            m_transLightAnchor.Rotate(Vector3.up, fTurnSpeedX * Time.deltaTime);

        }

        if (Input.GetKey(KeyCode.DownArrow))
        {
            m_transLightAnchor.Rotate(Vector3.up, -fTurnSpeedX * Time.deltaTime);

        }

        if (Input.GetKeyDown(KeyCode.Plus)|| Input.GetKeyDown(KeyCode.KeypadPlus))
        {
            m_lightSSS.intensity += 0.5f;
        }
        if (Input.GetKeyDown(KeyCode.Minus) || Input.GetKeyDown(KeyCode.KeypadMinus))
        {
            m_lightSSS.intensity -= 0.5f;
        }

        if(Input.GetKeyDown(KeyCode.Escape))
        {
            Application.Quit();
        }

        if(Input.GetKeyDown(KeyCode.D))
        {
            m_goDebugQuad.SetActive(!m_goDebugQuad.activeSelf);
        }
    }
}
